class Api::V1::UsersController < Api::V1::ApiController
  before_action :authenticate_request!, except: [:accept, :accept_invitation]
  before_action :authenticate_owner_or_manager!, only: [:index, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]

  def_param_group :user  do
    param :user, Hash do 
      param :email, String, desc: "Email of the user", required: true
      param :name, String, desc: "Name of the user"
      param :password, String, desc: "Password of the user"
      param :password_confirmation, String, desc: "Password confirmation of the user"
      param :role_id, String, desc: "Role of the user", required: true
    end
  end

  def_param_group :user_without_password  do
    param :user, Hash do 
      param :email, String, desc: "Email of the user", required: true
      param :name, String, desc: "Name of the user"
      param :role_id, String, desc: "Role of the user", required: true
    end
  end

  # ===================== Invitation part ============================

  # POST /api/v1/users/invite
  api :POST, "/users/invite", "Invite user by email"
  header 'Authentication', "User auth token"
  param_group :user_without_password
  formats ['json']
  def invite
    user = User.find_by_email(user_params[:email])

    unless user.present?
      user = User.invite(user_params, @current_user) # call class method `invite`
      
      if user.errors.any?
        render json: { error: user.errors.full_messages.join(", ") }, status: :unauthorized and return
      end
      
      InvitableMailer.invite_user(user, request.base_url).deliver

      render json: { success: "An invitation email has been sent to #{user.email}", user: user }
    else
      
      render json: { error: "The email address is already been taken" }, status: :unauthorized
    end
  end

  # PUT /api/v1/users/accept_invitation
  api :PUT, "/users/accept_invitation", "Accept and register user"
  param :invitation_token, String, desc: "Email of the user", required: true
  param :user, Hash do 
    param :password, String, desc: "Password of the user"
    param :password_confirmation, String, desc: "Password confirmation of the user"
  end
  formats ['json']
  def accept_invitation
    user = User.find_by_invitation_token(params[:invitation_token], true)

    unless user.present?
      render json: { error: "The invitation token provided is not valid!" }, status: :unauthorized and return
    end

    user = User.accept_invitation!(user_params.merge(invitation_token: params[:invitation_token]))

    render json: payload(user)
  end

  # ===================== Invitation part end ============================

  # GET /api/v1/users
  api :GET, "/users", "Get list of users based on current user's company"
  header 'Authentication', "User auth token"
  formats ['json']
  def index
    @users = User.includes(:role).where(company_id: @current_user.company_id)

    render json: @users
  end

  # GET /api/v1/users/1
  api :GET, "/users/:id", "Get detail of the user"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "User ID"
  formats ['json']
  def show
    render json: @user
  end

  # POST /api/v1/users
  api :POST, "/users", "Post a new user"
  header 'Authentication', "User auth token"
  param_group :user
  formats ['json']
  def create
    @user = User.new(user_params)
    @user.company_id = @current_user.company_id

    if @user.save
      render json: @user, status: :created
    else
      render json: { error: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/1
  api :PATCH, "/users/:id", "Update user"
  api :PUT, "/users/:id", "Update user"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "User ID"
  param_group :user
  formats ['json']
  def update
    if @current_user.is_manager?
      if (@user.is_manager? || @user.is_owner?) && @current_user != @user
        render json: { error: "Not authorized, you can't update owner or another manager" }, status: :unauthorized and return
      end
    elsif @current_user.is_helper?
      unless @current_user.eql?(@user)
        render json: { error: "Not authorized, you only can update yourself" }, status: :unauthorized and return
      end
    end

    if @user.update(user_params)
      render json: @user
    else
      render json: { error: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1
  api :DELETE, "/users/:id", "Delete the user"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "User ID"
  formats ['json']
  def destroy
    if @current_user.eql?(@user)
      render json: { error: "Not authorized, you can't delete yourself " }, status: :unauthorized and return
      
    elsif @current_user.is_manager? && (@user.is_manager? || @user.is_owner?)
      render json: { error: "Not authorized, you can't delete owner or another manager " }, status: :unauthorized and return
    
    end

    @user.destroy

    render json: { success: "User successfully deleted" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :role_id)
    end
end

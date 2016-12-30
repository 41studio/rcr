class Api::V1::UsersController < Api::V1::ApiController
  before_action :authenticate_request!
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
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/1
  api :PATCH, "/users/:id", "Update user"
  api :PUT, "/users", "Update user"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "User ID"
  param_group :user
  formats ['json']
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1
  api :DELETE, "/users/:id", "Delete the user"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "User ID"
  formats ['json']
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role_id)
    end
end

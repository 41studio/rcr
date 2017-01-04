class Api::V1::UserRegistrationController < Api::V1::ApiController

  def_param_group :user  do
    param :user, Hash do 
      param :email, String, desc: "Email of the user", required: true
      param :password, String, desc: "Password of the user", required: true
      param :name, String, desc: "Name of the user"
      param :password_confirmation, String, desc: "Password confirmation of the user", required: true
    end
  end
  
  # POST /api/v1/register_user
  api :POST, "/register_user", "Register new user"
  param_group :user
  param :company, String, required: true, desc: "Company of the user"
  formats ['json']
  def register_user
    owner_role = Role.find_by_name("owner")
    user = User.new(user_params)
    user.role_id = owner_role.id
    user.build_company(name: params[:company])

    if user.save
      render json: payload(user)
    else
      render json: { statusCode: 401, errors: user.errors.full_messages.join(", ") }, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email, role: user.role.try(:name), name: user.name}
    }
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
  
end
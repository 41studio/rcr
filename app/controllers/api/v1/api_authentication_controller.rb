class Api::V1::ApiAuthenticationController < Api::V1::ApiController
  
  # POST /api/v1/auth_user
  api :POST, "/auth_user", "Authentication user"
  param :email, String, required: true, desc: "Email of user"
  param :password, String, required: true, desc: "Password of user"
  formats ['json']
  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user
      if user.valid_password?(params[:password])
        render json: payload(user)
      else
        render json: { error: 'Invalid Password' }, status: :unauthorized
      end
    else
      render json: { error: 'Email not found' }, status: :unauthorized
    end
  end
end
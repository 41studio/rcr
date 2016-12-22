class Api::V1::UserRegistrationController < Api::V1::ApiController
  def register_user
    user = User.new(user_params)
    user.build_company(name: params[:company])

    if user.save
      render json: payload(user)
    else
      render json: {errors: user.errors}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email}
    }
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role_id)
  end
  
end
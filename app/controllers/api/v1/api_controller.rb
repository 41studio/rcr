class Api::V1::ApiController < ActionController::API
  attr_reader :current_user

  protected

    def authenticate_request!
      unless user_id_in_token?
        render json: { error: 'Not Authenticated' }, status: :unauthorized
        return
      end
      @current_user = User.find(auth_token[:user_id])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Not Authenticated' }, status: :unauthorized
    end

    def authenticate_owner_or_manager!
      unless @current_user.is_owner? || @current_user.is_manager?
        render json: { error: 'Not authorized, for owner and manager role only' }, status: :unauthorized
      end
    end

  private
  
    def pagination_dict(object)
      {
        current_page: object.current_page,
        next_page:    object.next_page,
        prev_page:    object.prev_page,
        total_pages:  object.total_pages,
        total_count:  object.total_count
      }
    end

    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def auth_token
      @auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_i
    end

    def payload(user)
      return nil unless user and user.id
      {
        auth_token: JsonWebToken.encode({user_id: user.id}),
        user: { id: user.id, email: user.email, role: user.role.try(:name), name: user.name }
      }
    end
end

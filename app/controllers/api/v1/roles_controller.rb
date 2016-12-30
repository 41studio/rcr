class Api::V1::RolesController < Api::V1::ApiController
  # GET /api/v1/roles
  api :GET, "/roles", "Get list of roles"
  header 'Authentication', "User auth token"
  formats ['json']
  def index
    roles = Role.select(:name, :id).where.not(name: "owner")

    render json: roles
  end

end

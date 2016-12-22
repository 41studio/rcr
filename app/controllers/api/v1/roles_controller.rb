class Api::V1::RolesController < Api::V1::ApiController
  # GET /api/v1/roles
  def index
    roles = Role.select(:name, :id)

    render json: roles
  end

end

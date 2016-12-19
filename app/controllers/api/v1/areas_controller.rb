class Api::V1::AreasController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_area, only: [:show, :update, :destroy]

  # GET /areas
  def index
    company = Company.find(@current_user.company_id)
    @areas = company.areas

    render json: @areas, each_serializer: AreaListSerializer
  end

  # GET /areas/1
  def show
    render json: @area
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def area_params
      params.require(:area).permit(:name)
    end
end

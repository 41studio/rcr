class Api::V1::AreasController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_area, only: [:show, :update, :destroy]

  # GET /api/v1/areas
  def index
    company = Company.find(@current_user.company_id)
    @areas = company.areas

    render json: @areas, each_serializer: AreaListSerializer
  end

  # GET /api/v1/areas/1
  def show
    render json: @area
  end


  # POST /api/v1/areas
  def create
    @area = Area.new(area_params)
    @area.company_id = @current_user.company_id

    if @area.save
      render json: @area, status: :created
    else
      render json: @area.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/areas/1
  def update
    if @area.update(area_params)
      render json: @area
    else
      render json: @area.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appraisals/1
  def destroy
    @area.delete
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

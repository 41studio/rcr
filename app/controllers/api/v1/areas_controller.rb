class Api::V1::AreasController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_area, only: [:show, :clone, :update, :destroy]

  def_param_group :area  do
    param :area, Hash do 
      param :name, String, desc: "Name of the area"
    end
  end

  # GET /api/v1/areas
  api :GET, "/areas", "Get list of areas"
  header 'Authentication', "User auth token"
  param :page, String, desc: "For pagination"
  param :name, String, desc: "The keyword for searching area"
  formats ['json']
  def index
    @areas = Area.where(company_id: @current_user.company_id)
      .search(params[:name])
      .page(params[:page]).per(10)

    render json: @areas, meta: pagination_dict(@areas), each_serializer: AreaListSerializer
  end

  # GET /api/v1/areas/1
  api :GET, "/areas/:id", "Get detail of the area"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "Area ID"
  param :date, String, desc: "Date for filter appraisals"
  param :page, String, desc: "For pagination"
  param :name, String, desc: "The keyword for searching item on area"
  formats ['json']
  def show
    @area.search_date = (params[:date].present? ? params[:date] : Date.today)
    items = @area.items.includes(:item_times)
      .search(params[:name])
      .page(params[:page]).per(10)

    context = { name: params[:name], page: params[:page], items: items }
    
    render json: @area, context: context, meta: pagination_dict(items)
  end

  # POST /api/v1/areas/1/clone
  api :POST, "/areas/:id/clone", "Clone area"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "Area ID"
  param_group :area
  formats ['json']
  def clone
    @cloned_area = @area.amoeba_dup
    @cloned_area.name = area_params[:name] if area_params[:name].present?

    if @cloned_area.save
      render json: @cloned_area, status: :created
    else
      render json: { error: @cloned_area.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/areas
  api :POST, "/areas", "Post a new area"
  header 'Authentication', "User auth token"
  param_group :area
  formats ['json']
  def create
    @area = Area.new(area_params)
    @area.company_id = @current_user.company_id

    if @area.save
      render json: @area, status: :created
    else
      render json: { error: @area.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/areas/1
  api :PATCH, "/areas/:id", "Update area"
  api :PUT, "/areas/:id", "Update area"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "Area ID"
  param_group :area
  formats ['json']
  def update
    if @area.update(area_params)
      render json: @area
    else
      render json: { error: @area.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/areas/1
  api :DELETE, "/areas/:id", "Delete area"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "Area ID"
  formats ['json']
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

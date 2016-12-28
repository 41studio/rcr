class Api::V1::ItemsController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /api/v1/areas/:area_id/items
  def index
    area = Area.find(params[:area_id])
    @items = area.items.includes(:item_times)

    render json: @items
  end

  # GET /api/v1/areas/:area_id/items/1
  def show
    render json: @item, serializer: ItemDetailSerializer
  end


  # POST /api/v1/areas/:area_id/items
  def create
    @item = Item.new(item_params)
    @item.area_id = params[:area_id]

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/areas/:area_id/items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/areas/:area_id/items/1
  def destroy
    @item.delete
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:name, item_times_attributes: [:time, :_destroy, :id])
    end
end
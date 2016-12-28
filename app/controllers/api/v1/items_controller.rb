class Api::V1::ItemsController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_item, only: [:show, :update, :destroy]

  def_param_group :item  do
    param :item, Hash do 
      param :name, String, desc: "Name of the item"
      param :item_times_attributes, Array do
        param "", Hash do 
          param :time, String, desc: "Time of the item time"
          param :_destroy, String, desc: "State for delete the item time"
          param :id, String, desc: "Item time ID"
        end
      end 
    end
  end

  # GET /api/v1/areas/:area_id/items
  api :GET, "/areas/:area_id/items", "Get list of items"
  header 'Authentication', "User auth token"
  param :area_id, String, required: true, desc: "Area ID of items"
  formats ['json']
  def index
    area = Area.find(params[:area_id])
    @items = area.items.includes(:item_times)

    render json: @items
  end

  # GET /api/v1/areas/:area_id/items/1
  api :GET, "/areas/:area_id/items/:id", "Get detail of item"
  header 'Authentication', "User auth token"
  param :area_id, String, required: true, desc: "Area ID of items"
  param :id, String, required: true, desc: "Item ID"
  formats ['json']
  def show
    render json: @item, serializer: ItemDetailSerializer
  end


  # POST /api/v1/areas/:area_id/items
  api :POST, "/areas/:area_id/items", "Create a new item based on Area"
  header 'Authentication', "User auth token"
  param :area_id, String, required: true, desc: "Area ID of items"
  param_group :item
  formats ['json']
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
  api :PATCH, "/areas/:area_id/items/:id", "Update an item"
  api :PUT, "/areas/:area_id/items/:id", "Update an item"
  header 'Authentication', "User auth token"
  param :area_id, String, required: true, desc: "Area ID of items"
  param :id, String, required: true, desc: "Item ID"
  param_group :item
  formats ['json']
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/areas/:area_id/items/1
  api :DELETE, "/areas/:area_id/items/:id", "Delete an item"
  header 'Authentication', "User auth token"
  param :area_id, String, required: true, desc: "Area ID of items"
  param :id, String, required: true, desc: "Item ID"
  formats ['json']
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

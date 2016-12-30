class Api::V1::AppraisalsController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :authenticate_manager!, only: [:update]
  before_action :authenticate_helper!,  only: [:create]
  before_action :set_appraisal, only: [:show, :update, :destroy]
  before_action :check_existing_appraisal, only: [:create]

  def_param_group :appraisal  do
    param :appraisal, Hash do
      param :description, String, desc: "Description of the appraisal"
      param :checked, String, desc: "Checked of the appraisal"
      param :item_time_id, String, desc: "Item time ID of the appraisal"
      param :indicator_id, String, desc: "Indicator ID of the appraisal", required: true
      param :manager_id, String, desc: "Manager ID of the appraisal"
      param :helper_id, String, desc: "Helper ID of the appraisal"
    end
  end

  # GET /api/v1/appraisals
  api :GET, "/appraisals", "Get list of appraisals"
  header 'Authentication', "User auth token"
  formats ['json']
  def index
    @appraisals = Appraisal.joins(:item_time => [:item => [:area => [:company]]]).where("companies.id = ?", @current_user.company_id)

    render json: @appraisals
  end

  # GET /api/v1/appraisals/1
  api :GET, "/appraisals/:id", "Get detail of the appraisal"
  header 'Authentication', "User auth token"
  param :id, String, required: true, desc: "Appraisal ID"
  formats ['json']
  def show
    render json: @appraisal
  end

  # POST /api/v1/appraisals
  # This is for helper role only
  # api :POST, "/appraisals/:id", "Post a new appraisal"
  # header 'Authentication', "User auth token"
  # param_group :appraisal
  # formats ['json']
  def create
    @appraisal = Appraisal.new(appraisal_params)
    @appraisal.helper_id = @current_user.id
    @appraisal.checked = true

    if @appraisal.save
      render json: @appraisal, status: :created
    else
      render json: @appraisal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/appraisals/1
  # This is for manager level only
  # api :PATCH, "/appraisals/:id", "Update appraisal"
  # api :PUT, "/appraisals/:id", "Update appraisal"
  # header 'Authentication', "User auth token"
  # param :id, String, required: true, desc: "Appraisal ID"
  # param_group :appraisal
  # formats ['json']
  def update
    @appraisal.manager_id = @current_user.id
    if @appraisal.update(appraisal_params)
      render json: @appraisal
    else
      render json: @appraisal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appraisals/1
  # api :DELETE, "/appraisals/:id", "Delete appraisal"
  # header 'Authentication', "User auth token"
  # param :id, String, required: true, desc: "Appraisal ID"
  # formats ['json']
  def destroy
    @appraisal.destroy
  end

  protected

    def check_existing_appraisal
      appraisals = ItemTime.find(appraisal_params[:item_time_id]).appraisals.by_day(Date.today)

      if appraisals.exists?
        render json: {errors: ['Appraisal already exist']}, status: :unprocessable_entity
      end
    end

    def authenticate_manager!
      unless @current_user.is_manager?
        render json: { errors: ['Not Authenticated, for manager role only'] }, status: :unauthorized
      end
    end
    
    def authenticate_helper!
      unless @current_user.is_helper?
        render json: { errors: ['Not Authenticated, for helper role only'] }, status: :unauthorized
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appraisal
      @appraisal = Appraisal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def appraisal_params
      params.require(:appraisal).permit(:description, :indicator_id, :item_time_id, :manager_id, :helper_id)
    end

end
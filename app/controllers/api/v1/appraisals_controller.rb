class Api::V1::AppraisalsController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_appraisal, only: [:show, :update, :destroy]

  # GET /api/v1/appraisals
  def index
    @appraisals = Appraisal.joins(:item_time => [:item => [:area => [:company]]]).where("companies.id = ?", @current_user.company_id)

    render json: @appraisals
  end

  # GET /api/v1/appraisals/1
  def show
    render json: @appraisal
  end

  # POST /api/v1/appraisals
  def create
    @appraisal = Appraisal.new(appraisal_params)

    if @appraisal.save
      render json: @appraisal, status: :created, location: @appraisal
    else
      render json: @appraisal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/appraisals/1
  def update
    if @appraisal.update(appraisal_params)
      render json: @appraisal
    else
      render json: @appraisal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appraisals/1
  def destroy
    @appraisal.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appraisal
      @appraisal = Appraisal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def appraisal_params
      params.require(:appraisal).permit(:date, :description, :indicator_id, :item_time_id, :manager_id, :helper_id)
    end

end
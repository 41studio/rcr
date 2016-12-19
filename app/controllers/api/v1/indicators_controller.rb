class Api::V1::IndicatorsController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :set_indicator, only: [:show, :update, :destroy]

  # GET /api/v1/indicators
  def index
    @indicators = Indicator.select(:id, :code, :description)

    render json: @indicators
  end

end

class Api::IndicatorsController < Api::ApiController
  before_action :authenticate_request!
  before_action :set_indicator, only: [:show, :update, :destroy]

  # GET /indicators
  def index
    @indicators = Indicator.select(:id, :code, :description)

    render json: @indicators
  end

end

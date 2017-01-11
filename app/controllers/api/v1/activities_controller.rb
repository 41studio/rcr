class Api::V1::ActivitiesController < Api::V1::ApiController
  before_action :authenticate_request!
  before_action :check_available_timezone

  # GET /api/v1/activities
  api :GET, "/activities", "Get list of activities based on company"
  header 'Authentication', "User auth token"
  param :date, String, desc: "Date of activities"
  param :timezone, String, desc: "To get time based on timezone"
  param :page, String, desc: "For pagination"
  formats ['json']
  def index
    @activities = Activity.joins_with_trackable(@current_user, params[:date]).page(params[:page]).per(10)

    render json: @activities, meta: pagination_dict(@activities), context: { timezone: params[:timezone] }, each_serailizer: ActivitySerializer
  end

  private

  def check_available_timezone
    timezones = ActiveSupport::TimeZone::MAPPING.values
    
    if params[:timezone].present?
      unless timezones.include?(params[:timezone])
        render json: { error: "Invalid timezone" }, status: :unprocessable_entity
      end
    end
  end

end
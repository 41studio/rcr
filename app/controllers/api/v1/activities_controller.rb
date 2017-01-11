class Api::V1::ActivitiesController < Api::V1::ApiController
  before_action :authenticate_request!

  # GET /api/v1/activities
  api :GET, "/activities", "Get list of activities"
  header 'Authentication', "User auth token"
  param :date, String, desc: "Date of activities"
  param :timezone, String, desc: "To get time based on timezone"
  formats ['json']
  def index
    @activities = Activity.joins_with_trackable(@current_user, params[:date])

    render json: @activities, context: { timezone: params[:timezone] }, each_serailizer: ActivitySerializer
  end

end
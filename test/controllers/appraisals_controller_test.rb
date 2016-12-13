require 'test_helper'

class AppraisalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appraisal = appraisals(:one)
  end

  test "should get index" do
    get appraisals_url, as: :json
    assert_response :success
  end

  test "should create appraisal" do
    assert_difference('Appraisal.count') do
      post appraisals_url, params: { appraisal: { date: @appraisal.date, description: @appraisal.description } }, as: :json
    end

    assert_response 201
  end

  test "should show appraisal" do
    get appraisal_url(@appraisal), as: :json
    assert_response :success
  end

  test "should update appraisal" do
    patch appraisal_url(@appraisal), params: { appraisal: { date: @appraisal.date, description: @appraisal.description } }, as: :json
    assert_response 200
  end

  test "should destroy appraisal" do
    assert_difference('Appraisal.count', -1) do
      delete appraisal_url(@appraisal), as: :json
    end

    assert_response 204
  end
end

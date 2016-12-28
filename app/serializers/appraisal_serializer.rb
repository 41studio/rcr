class AppraisalSerializer < ActiveModel::Serializer
  attributes :id, :checked, :description, :result_detail

  def result_detail
    {
      indicator: object.indicator.description,
      helper: object.helper,
      manager: object.manager,
      checked_at: object.created_at,
      approved_at: (object.manager ? object.updated_at : "-")
    }
  end
end
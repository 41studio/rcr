class Activity < ApplicationRecord

  def self.joins_with_trackable(current_user, date)
    conditions = ["users.company_id = :company_id"]
    parameters = { company_id: current_user.company_id } 

    if date.present?
      conditions << "DATE(activities.created_at) = :date"
      parameters.merge!({ date: date })
    end

    PublicActivity::Activity.select("activities.id, activities.key, activities.created_at, users.id AS user_id, 
      users.name AS user_name, appraisals.id AS appraisal_id, items.name AS item_name, areas.name AS area_name")
    .joins("INNER JOIN users ON activities.owner_id = users.id AND activities.owner_type = 'User'
      INNER JOIN appraisals ON activities.trackable_type = 'Appraisal' AND activities.trackable_id = appraisals.id
      INNER JOIN item_times ON appraisals.item_time_id = item_times.id
      INNER JOIN items ON items.id = item_times.item_id INNER JOIN areas ON areas.id = items.area_id")
    .where(conditions.join(" AND "), parameters)
    .order("activities.created_at DESC")
  end 
end
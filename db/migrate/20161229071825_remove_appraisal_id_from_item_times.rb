class RemoveAppraisalIdFromItemTimes < ActiveRecord::Migration[5.0]
  def change
    remove_column :item_times, :appraisal_id, :integer
  end
end

class AddAppraisalIdToItemTimes < ActiveRecord::Migration[5.0]
  def change
    add_reference :item_times, :appraisal, foreign_key: true
  end
end

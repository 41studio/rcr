class RemoveColumnDateFromAppraisals < ActiveRecord::Migration[5.0]
  def change
    remove_column :appraisals, :date, :date
  end
end

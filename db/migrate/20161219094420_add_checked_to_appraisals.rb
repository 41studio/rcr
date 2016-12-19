class AddCheckedToAppraisals < ActiveRecord::Migration[5.0]
  def change
    add_column :appraisals, :checked, :boolean, default: false
    remove_column :appraisals, :item_id
  end
end

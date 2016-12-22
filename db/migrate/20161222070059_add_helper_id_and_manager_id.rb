class AddHelperIdAndManagerId < ActiveRecord::Migration[5.0]
  def change
    add_column :appraisals, :manager_id, :integer
    add_column :appraisals, :helper_id, :integer
  end
end

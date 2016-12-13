class CreateAppraisals < ActiveRecord::Migration[5.0]
  def change
    create_table :appraisals do |t|
      t.references :item_time
      t.references :item
      t.references :indicator
      t.date :date
      t.string :description

      t.timestamps
    end
  end
end

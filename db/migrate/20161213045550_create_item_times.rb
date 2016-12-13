class CreateItemTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :item_times do |t|
      t.references :item, foreign_key: true
      t.string :time

      t.timestamps
    end
  end
end

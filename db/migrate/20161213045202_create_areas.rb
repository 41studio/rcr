class CreateAreas < ActiveRecord::Migration[5.0]
  def change
    create_table :areas do |t|
      t.references :company, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end

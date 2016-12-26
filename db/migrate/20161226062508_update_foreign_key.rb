class UpdateForeignKey < ActiveRecord::Migration[5.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :users, :companies
    remove_foreign_key :users, :roles
    remove_foreign_key :areas, :companies
    remove_foreign_key :items, :areas
    remove_foreign_key :item_times, :items
    
    # add the new foreign_key
    add_foreign_key :users, :companies, on_delete: :cascade
    add_foreign_key :users, :roles, on_delete: :cascade
    add_foreign_key :areas, :companies, on_delete: :cascade
    add_foreign_key :items, :areas, on_delete: :cascade
    add_foreign_key :item_times, :items, on_delete: :cascade
  end
end

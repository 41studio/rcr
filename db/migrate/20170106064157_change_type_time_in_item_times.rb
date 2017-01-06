class ChangeTypeTimeInItemTimes < ActiveRecord::Migration[5.0]
  def change
    remove_column :item_times, :time, :string
    
    add_column :item_times, :time, :time
  end
end

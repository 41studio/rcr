class AreaSerializer < ActiveModel::Serializer
  attributes :id, :name, :item_list

  def item_list
    item_list = []
    object.items.includes(:item_times).each do |item|
      item_times_area = []
      item_area = { id: item.id, name: item.name }
      
      item.item_times.each do |item_time|
        item_times_area << {id: item_time.id, time: item_time.time, current_time: object.current_time}
      end

      item_area[:times] = item_times_area
      
      item_list << item_area
    end
    item_list
  end

end
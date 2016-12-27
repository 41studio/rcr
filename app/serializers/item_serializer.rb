class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :times

  def times
    times = []
    object.item_times.each do |item|
      times << {id: item.id, time: item.time}
    end
    times
  end
end
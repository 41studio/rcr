class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :times

  def times
    times = []
    object.item_times.sort_by { |item_time| item_time.time.to_i }.each do |item|
      times << {id: item.id, time: item.time}
    end
    times
  end
end
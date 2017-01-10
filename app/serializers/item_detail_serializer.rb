class ItemDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :times

  def times
    times = []
    object.item_times.each do |item|
      times << { id: item.id, time: item.time.strftime("%H:%M") }
    end
    times
  end

end
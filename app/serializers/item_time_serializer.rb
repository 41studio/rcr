class ItemTimeSerializer < ActiveModel::Serializer
  attributes :id, :time, :formatted_time

  def formatted_time
    object.time.strftime("%H:%M")
  end
end
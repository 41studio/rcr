class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :date, :time, :content

  def date
    object.created_at.to_date
  end

  def time
    context = @instance_options[:context]

    time = 
      if context[:timezone].present?
        object.created_at.in_time_zone(context[:timezone])
      else
        object.created_at
      end

    time.strftime("%H:%M")
  end

  def content
    keyword =
      case object.key 
      when "appraisal.checked_on"
        then " checklist "
      when "appraisal.rated_on"
        then " give rate "
      end

    object.user_name + keyword + object.item_name + " item on " + object.area_name + " area." 

  end
end
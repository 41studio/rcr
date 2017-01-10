class AreaSerializer < ActiveModel::Serializer
  attributes :id, :name, :item_list

  def item_list
    item_list = []

    object.items.includes(:item_times).each do |item|
      item_times_area = []
      item_area = { id: item.id, name: item.name }
      
      item.item_times.each do |item_time|
        item_area_member = { id: item_time.id, time: item_time.time.strftime("%H:%M") }        
        appraisal_item   = item_time.appraisals.by_day(object.search_date).includes(:indicator).last
        
        if appraisal_item.present?
          indicator = appraisal_item.indicator
          
          appraisal_item = 
            appraisal_item.attributes.delete_if { |key| ['created_at', 'updated_at'].include? key }.merge(
              { 
                indicator_code: indicator ? indicator.code : '-', 
                indicator_description: indicator ? indicator.description : '-',
                checked_at: appraisal_item.created_at.strftime("%Y-%m-%d"), 
                reviewed_at: appraisal_item.updated_at.strftime("%Y-%m-%d")
              }
            )
        end

        item_times_area << item_area_member.merge({ appraisals: appraisal_item })
      end

      item_list << item_area.merge({ times: item_times_area })
    end

    if @instance_options[:context].present?
      Kaminari.paginate_array(item_list).page(@instance_options[:context][:page]).per(10)
    else
      item_list
    end
  end

end
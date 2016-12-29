class AreaSerializer < ActiveModel::Serializer
  attributes :id, :name, :item_list

  def item_list
    item_list = []
    object.items.includes(:item_times).each do |item|
      item_times_area = []
      item_area = { id: item.id, name: item.name }
      
      item.item_times.each do |item_time|
        appraisal_items = []
        item_area_member = {id: item_time.id, time: item_time.time}

        item_time.appraisals.includes(:indicator).by_day(object.search_date).each do |appraisal|
          appraisal_items << appraisal.attributes.delete_if {|key| ['created_at', 'updated_at'].include? key }.merge(
            { indicator_code: appraisal.indicator.code, indicator_description: appraisal.indicator.description, 
              checked_at: appraisal.created_at.strftime("%Y-%m-%d"), reviewed_at: appraisal.updated_at.strftime("%Y-%m-%d") })
        end

        item_area_member[:appraisals] = appraisal_items

        item_times_area << item_area_member
      end

      item_area[:times] = item_times_area
      
      item_list << item_area
    end
    item_list
  end

end
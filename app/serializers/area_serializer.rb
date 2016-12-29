class AreaSerializer < ActiveModel::Serializer
  attributes :id, :name, :item_list

  def item_list
    item_list = []

    object.items.includes(:item_times).each do |item|
      item_times_area = []
      item_area = { id: item.id, name: item.name }
      
      item.item_times.each do |item_time|
        # appraisal_items = []
        item_area_member = { id: item_time.id, time: item_time.time }

        # item_time.appraisals.includes(:indicator).by_day(object.search_date).each do |appraisal|
        #   indicator = appraisal.indicator

        #   appraisal_item = appraisal.attributes.delete_if {|key| ['created_at', 'updated_at'].include? key }.merge(
        #     { indicator_code: indicator ? indicator.code : '-', indicator_description: indicator ? indicator.description : '-', 
        #       checked_at: appraisal.created_at.strftime("%Y-%m-%d"), reviewed_at: appraisal.updated_at.strftime("%Y-%m-%d") })
        # end
        
        appraisal_item = item_time.appraisals.by_day(object.search_date).includes(:indicator).last
        
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

    item_list
  end

end
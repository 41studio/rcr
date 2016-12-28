class Appraisal < ApplicationRecord
  belongs_to :item_time
  belongs_to :indicator

  def helper
    User.find(self.helper_id).try(:email)
  end

  def manager
    User.find(self.manager_id).try(:email) rescue nil
  end

end

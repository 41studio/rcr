class Appraisal < ApplicationRecord
  belongs_to :item_time, optional: true
  belongs_to :indicator, optional: true

  delegate :description, to: :indicator, prefix: true,  allow_nil: true

  include PublicActivity::Model
  tracked

  def helper
    User.find(self.helper_id).try(:email)
  end

  def manager
    User.find(self.manager_id).try(:email) rescue nil
  end

end

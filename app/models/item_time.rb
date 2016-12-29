class ItemTime < ApplicationRecord
  belongs_to :item, optional: true

  has_many :appraisals, dependent: :destroy
end

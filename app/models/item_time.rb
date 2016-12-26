class ItemTime < ApplicationRecord
  belongs_to :item, optional: true
end

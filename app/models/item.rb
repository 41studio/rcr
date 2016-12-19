class Item < ApplicationRecord
  belongs_to :area
  has_many :item_times
end

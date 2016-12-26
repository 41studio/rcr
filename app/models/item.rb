class Item < ApplicationRecord
  belongs_to :area
  has_many :item_times
  accepts_nested_attributes_for :item_times, allow_destroy: true
end
class Area < ApplicationRecord
  belongs_to :company
  has_many :items
end

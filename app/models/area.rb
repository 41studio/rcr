class Area < ApplicationRecord
  belongs_to :company
  has_many :items

  attr_accessor :current_time
end

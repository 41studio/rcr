class Area < ApplicationRecord
  belongs_to :company
  has_many :items

  attr_accessor :search_date

  scope :search, -> (name) { where("LOWER(name) LIKE ?", "%#{name.to_s.downcase}%") }

  amoeba do
    include_association :items
  end

  
end

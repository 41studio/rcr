class Area < ApplicationRecord
  belongs_to :company
  has_many :items

  attr_accessor :search_date

  amoeba do
    include_association :items
  end
end

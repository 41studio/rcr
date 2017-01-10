class Item < ApplicationRecord
  belongs_to :area
  has_many :item_times, -> { order(:time) }
  accepts_nested_attributes_for :item_times, allow_destroy: true

  validate :check_duplicate_times

  amoeba do
    include_association :item_times
  end

  private 

    def check_duplicate_times
      times = self.item_times.map(&:time)

      unless times.uniq.count.eql? times.count
        errors.add(:item_times, "have duplicate times")
      end
    end
end
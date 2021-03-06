# == Schema Information
#
# Table name: pledges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wishlist_item_id :integer
#  quantity         :integer          default(1), not null
#

require "active_record_csv_generator"

class Pledge < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :user

  validates :quantity, presence: true,
                       numericality: { greater_than_or_equal_to: 1 }
  validates :wishlist_item, uniqueness: { scope: :user }

  class << self
    def increment_or_new(params)
      if (pledge = find_duplicate(params))
        pledge.increment(:quantity)
      else
        new(params)
      end
    end

    def generate_csv(csv_generator: ActiveRecordCSVGenerator.new(self))
      csv_generator.generate
    end

    private

    def find_duplicate(params)
      uniq_keys = %w[user_id wishlist_item_id]
      uniq_params = params.keep_if { |key, _| key.to_s.in? uniq_keys }
      find_by(uniq_params)
    end
  end
end

class Question < ApplicationRecord
  validates :title, :option_1, :value_1, :option_2, :value_2, presence: true
  validates :option_1, :option_2, length: { maximum: 20 }
end

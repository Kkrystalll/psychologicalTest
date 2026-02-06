class Category < ApplicationRecord
  has_many :questions

  validates :name, :order, presence: true
end

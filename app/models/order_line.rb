# frozen_string_literal: true

# Model to handle object OrderLine
class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :order, presence: true
  validates :product, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

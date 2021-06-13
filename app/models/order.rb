# frozen_string_literal: true

# Model to handle object Order
class Order < ApplicationRecord
  has_many :order_lines

  validates :name, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
end

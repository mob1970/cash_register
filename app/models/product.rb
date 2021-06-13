# frozen_string_literal: true

# Model to handle object Product
class Product < ApplicationRecord
  has_many :order_lines

  validates :code, null: false, length: { in: 1..10 }
  validates :name, null: false, length: { in: 1..50 }
  validates :price, null: false, numericality: { greater_than: 0 }
end

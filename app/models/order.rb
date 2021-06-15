# frozen_string_literal: true

# Model to handle object Order
class Order < ApplicationRecord
  has_many :order_lines, autosave: true, dependent: :delete_all

  validates :name, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

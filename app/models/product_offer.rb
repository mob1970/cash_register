class ProductOffer < ApplicationRecord
  belongs_to :product

  validates :minimum_quantity, null: false, numericality: { greater_than: 0 }
  validates :new_price, null: false, numericality: { greater_than: 0 }
end

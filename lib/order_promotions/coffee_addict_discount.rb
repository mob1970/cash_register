# frozen_string_literal: true

require './lib/number_handling/operations'

module OrderPromotions
  # Class to handle the coffee discount
  class CoffeeAddictDiscount < Base
    register :coffee_addict_discount

    COFFEE_CODE = 'CF1'

    def self.adapt(order)
      coffee_product = Product.find_by(code: COFFEE_CODE)
      return order unless coffee_product.product_offer

      coffee_lines = order.order_lines.select { |line| line.product.code == COFFEE_CODE }.size
      new_price = if coffee_lines >= coffee_product.product_offer.minimum_quantity
        coffee_product.product_offer.new_price
      else
        coffee_product.price
      end

      order.order_lines.each do |line|
        line.price = new_price if line.product.code == COFFEE_CODE
      end

      order
    end

    def self.correct(order)
      order
    end
  end
end

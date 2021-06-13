# frozen_string_literal: true

require './lib/number_handling/operations'

module OrderAdapter
  # Class to handle the coffee discount
  class CoffeeAddictDiscount < Base
    register :coffee_addict_discount

    COFFEE_CODE = 'CF1'
    COFFEE_LINES_FOR_DISCOUNT = 3

    def self.handles?(product)
      product.code == COFFEE_CODE
    end

    def adapt(item, order)
      unless item.code == COFFEE_CODE
        raise(PriceHandlers::IncorrectProductError, "CoffeeAddictDiscount doesn't handle product #{item.code}.")
      end

      coffee_product = Product.find_by(code: COFFEE_CODE)
      coffee_lines = order.order_lines.select { |line| line.product.code == COFFEE_CODE }.size

      return order unless coffee_lines > COFFEE_LINES_FOR_DISCOUNT

      price = NumberHandling::Operations.convert_to_decimals(coffee_product.price * 0.66, 2)
      order.order_lines.each do |line|
        line.price = price if line.product.code == COFFEE_CODE
      end

      order
    end
  end
end

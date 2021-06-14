# frozen_string_literal: true

module OrderPromotions
  # Class to handle the coffee discount
  class StrawberriesAddictDiscount < Base
    register :strawberry_addict_discount

    STRAWBERRIES_CODE = 'SR1'
    STRAWBERRIES_LINES_FOR_DISCOUNT = 3
    STRAWBERRIES_FIXED_PRICE = 4.50

    def self.adapt(order)
      coffee_lines = order.order_lines.select { |line| line.product.code == STRAWBERRIES_CODE }.size

      return order unless coffee_lines >= STRAWBERRIES_LINES_FOR_DISCOUNT

      order.order_lines.each do |line|
        line.price = STRAWBERRIES_FIXED_PRICE if line.product.code == STRAWBERRIES_CODE
      end

      order
    end
  end
end

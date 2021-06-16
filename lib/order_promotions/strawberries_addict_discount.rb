# frozen_string_literal: true

module OrderPromotions
  # Class to handle the coffee discount
  class StrawberriesAddictDiscount < Base
    register :strawberry_addict_discount

    STRAWBERRIES_CODE = 'SR1'
    STRAWBERRIES_LINES_FOR_DISCOUNT = 3
    STRAWBERRIES_FIXED_PRICE = 4.50

    def self.adapt(order)
      strawberry_product = Product.find_by(code: STRAWBERRIES_CODE)
      strawberry_lines = order.order_lines.select { |line| line.product.code == STRAWBERRIES_CODE }.size

      new_price = if strawberry_lines >= STRAWBERRIES_LINES_FOR_DISCOUNT
                    STRAWBERRIES_FIXED_PRICE
                  else
                    strawberry_product.price
                  end

      order.order_lines.each do |line|
        line.price = new_price if line.product.code == STRAWBERRIES_CODE
      end

      order
    end

    def self.correct(order)
      order
    end
  end
end

# frozen_string_literal: true

require './lib/number_handling/operations'

module OrderAdapter
  # Class to handle the coffee discount
  class GreenTeaForFree < Base
    register :coffee_addict_discount

    GREEN_TEA_CODE = 'GR1'

    def self.handles?(product)
      product.code == GREEN_TEA_CODE
    end

    def adapt(item, order)
      unless item.code == GREEN_TEA_CODE
        raise(PriceHandlers::IncorrectProductError, "GreenTeaForFree doesn't handle product #{item.code}.")
      end

      green_tea_product = Product.find_by(code: GREEN_TEA_CODE)
      green_tea_lines = order.order_lines.select { |line| line.product.code == GREEN_TEA_CODE }.size

      green_tea_lines.times do
        order.order_lines << OrderLine.new(product: green_tea_product, price: 0)
      end

      order
    end
  end
end

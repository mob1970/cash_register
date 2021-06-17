# frozen_string_literal: true

module OrderPromotions
  # Class to handle the green tea discount
  class GreenTeaForFree < Base
    register :green_tea_for_free

    GREEN_TEA_CODE = 'GR1'

    def self.adapt(order)
      green_tea_product = Product.find_by(code: GREEN_TEA_CODE)

      return order unless green_tea_product.product_offer

      green_tea_lines = order.order_lines.select { |line| line.product.code == GREEN_TEA_CODE }
      if green_tea_lines.size.odd?
        # if there is an odd number of green tea we have to add an additional one for free
        order.order_lines << OrderLine.new(product: green_tea_product, price: green_tea_product.product_offer.new_price) if green_tea_lines.size.odd?
        green_tea_lines = order.order_lines.select { |line| line.product.code == GREEN_TEA_CODE }
      end

      green_tea_lines.each_with_index do |order_line, index|
        order_line.price = green_tea_product.product_offer.new_price if index.odd?
      end

      order
    end

    def self.correct(order)
      green_tea_lines = order.order_lines.select { |line| line.product.code == GREEN_TEA_CODE }
      green_tea_with_price = green_tea_lines.select { |line| line.price > 0 }
      green_tea_for_free = green_tea_lines.select { |line| line.price == 0 }

      green_tea_to_remove = green_tea_with_price.size > green_tea_for_free.size ? green_tea_with_price : green_tea_for_free
      order.order_lines.delete(green_tea_to_remove.last) if green_tea_to_remove.size > 0

      order
    end
  end
end

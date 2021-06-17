# frozen_string_literal: true

require 'rails_helper'
require './lib/order_promotions/base'
require './lib/order_promotions/coffee_addict_discount'
require './lib/order_promotions/green_tea_for_free'
require './lib/order_promotions/strawberries_addict_discount'

describe OrderPromotions::OrderPromotionsHandler do
  let(:green_tea_product_offer) { ProductOffer.new(product_id: 1, minimum_quantity: 1, new_price: 0.000) }
  let(:strawberry_product_offer) { ProductOffer.new(product_id: 2, minimum_quantity: 3, new_price: 4.500) }
  let(:coffee_product_offer) { ProductOffer.new(product_id: 3, minimum_quantity: 3, new_price: 7.410) }
  let(:green_tea_product) { Product.new(code: 'GR1', name: 'Green Tea', price: 3.11, product_offer: green_tea_product_offer) }
  let(:strawberry_product) { Product.new(code: 'SR1', name: 'Strawberry', price: 5.00, product_offer: strawberry_product_offer) }
  let(:coffee_product) { Product.new(code: 'CF1', name: 'Coffee', price: 10.00, product_offer: coffee_product_offer) }

  let(:coffee_item) { OrderLine.new(product: coffee_product, price: 10.00) }
  let(:price_with_discount_applied) { 7.410 }
  let(:green_tea_item) { OrderLine.new(product: green_tea_product, price: 3.11) }
  let(:strawberry_item) { OrderLine.new(product: strawberry_product, price: 5.00) }

  let(:modified_coffee_item) { OrderLine.new(product: coffee_product, price: price_with_discount_applied) }
  let(:modified_green_tea_item) { OrderLine.new(product: green_tea_product, price: 0.00) }
  let(:modified_strawberry_item) { OrderLine.new(product: strawberry_product, price: 4.50) }

  before :each do
    allow(Product).to receive(:find_by).with(code: coffee_product.code).and_return(coffee_product)
    allow(Product).to receive(:find_by).with(code: green_tea_product.code).and_return(green_tea_product)
    allow(Product).to receive(:find_by).with(code: strawberry_product.code).and_return(strawberry_product)
  end

  context '#apply' do
    context 'one coffee, one green tea and one strawberry' do
      let(:order) { Order.new(name: 'Order', order_lines: [coffee_item, green_tea_item, strawberry_item]) }
      let(:returned_order) { Order.new(name: 'Returned Order', order_lines: [coffee_item, green_tea_item, strawberry_item, modified_green_tea_item]) }

      it 'must return the order with an additional green tea for free' do
        expect(described_class.apply(order).order_lines.map(&:price)).to eq(returned_order.order_lines.map(&:price))
      end
    end

    context 'one coffee, two green teas and one strawberry' do
      let(:order) { Order.new(name: 'Order', order_lines: [coffee_item, green_tea_item, green_tea_item, strawberry_item]) }
      let(:returned_order) { Order.new(name: 'Returned Order', order_lines: [coffee_item, green_tea_item, modified_green_tea_item, strawberry_item]) }

      it 'must return the same order' do
        expect(described_class.apply(order).order_lines.map(&:price)).to eq(returned_order.order_lines.map(&:price))
      end
    end

    context 'four coffees, one strawberry' do
      let(:order) { Order.new(name: 'Order', order_lines: [coffee_item, coffee_item, coffee_item, coffee_item, strawberry_item]) }
      let(:returned_order) { Order.new(name: ' Returned Order', order_lines: [modified_coffee_item, modified_coffee_item, modified_coffee_item, modified_coffee_item, strawberry_item]) }

      it 'must return the same order' do
        expect(described_class.apply(order).order_lines.map(&:price)).to eq(returned_order.order_lines.map(&:price))
      end
    end

    context 'one coffee and three strawberries' do
      let(:order) { Order.new(name: 'Order', order_lines: [coffee_item, strawberry_item, strawberry_item, strawberry_item]) }
      let(:returned_order) { Order.new(name: 'Returned Order', order_lines: [coffee_item, modified_strawberry_item, modified_strawberry_item, modified_strawberry_item]) }

      it 'must return the same order' do
        expect(described_class.apply(order).order_lines.map(&:price)).to eq(returned_order.order_lines.map(&:price))
      end
    end
  end
end

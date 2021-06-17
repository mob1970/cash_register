# frozen_string_literal: true

require 'rails_helper'
require './lib/order_promotions/base'
require './lib/order_promotions/coffee_addict_discount'

describe OrderPromotions::CoffeeAddictDiscount do
  let(:coffee_product) { Product.new(code: 'CF1', name: 'Coffee', price: 10.00) }
  let(:item_coffee) { OrderLine.new(product: coffee_product, price: 10.00) }
  let(:price_with_discount_applied) { NumberHandling::Operations.convert_to_decimals(item_coffee.price * 0.66, 2) }
  let(:item_coffee_modified) { OrderLine.new(product: coffee_product, price: price_with_discount_applied) }
  let(:item_green_tea) { double('Green Tea', code: 'GR1', price: 10.00) }
  let(:item) { item_coffee }
  let(:order) { double('Order') }
  let(:product_offer) { double('ProductOffer', product_id: 1, minimum_quantity: 1, new_price: 7.410) }

  describe '#adapt' do
    let(:product) { item }

    before :each do
      allow(Product).to receive(:find_by).with(code: coffee_product.code).and_return(coffee_product)
      allow_any_instance_of(Product).to receive(:product_offer).and_return(product_offer)
    end

    context 'discount applied' do
      let(:four_coffee_order) { double('Order', order_lines: [item_coffee, item_coffee, item_coffee, item_coffee]) }
      let(:four_coffee_order_modified) { double('Order', order_lines: [item_coffee_modified, item_coffee_modified, item_coffee_modified, item_coffee_modified, item_coffee_modified]) }

      it 'must apply the discount with more than three cofees' do
        expect(described_class.adapt(four_coffee_order).to_json).to eq(four_coffee_order_modified.to_json)
      end
    end

    context 'discount not applied' do
      let(:just_one_coffee_order) { double('Order', order_lines: [item_coffee]) }
      let(:three_coffee_order) {  double('Order', order_lines: [item_coffee, item_coffee, item_coffee]) }

      it 'must not apply the discount' do
        expect(described_class.adapt(just_one_coffee_order)).to eq(just_one_coffee_order)
      end

      it 'must not apply the discount with three cofees' do
        expect(described_class.adapt(three_coffee_order)).to eq(three_coffee_order)
      end
    end
  end

  describe '#adapt' do
    let(:item_coffee) { OrderLine.new(product: coffee_product, price: 10.00) }
    let(:just_one_coffee_order) { double('Order', order_lines: [item_coffee]) }

    it 'must return the order unmodified' do
      expect(described_class.correct(just_one_coffee_order)).to eq(just_one_coffee_order)
    end
  end
end

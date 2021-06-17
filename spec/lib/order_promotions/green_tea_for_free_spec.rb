# frozen_string_literal: true

require 'rails_helper'
require './lib/order_promotions/base'
require './lib/order_promotions/green_tea_for_free'

describe OrderPromotions::GreenTeaForFree do
  let(:green_tea_product) { Product.new(code: 'GR1', name: 'Green Tea', price: 3.11) }
  let(:coffee_product) { Product.new(code: 'CF1', name: 'Coffee', price: 10.00) }
  let(:item_green_tea) { OrderLine.new(product: green_tea_product, price: 3.11) }
  let(:item_green_tea_for_free) { OrderLine.new(product: green_tea_product, price: 0.00) }
  let(:item_coffee) { OrderLine.new(product: coffee_product, price: 10.00) }
  let(:item) { item_coffee }
  let(:order) { double('Order') }
  let(:product_offer) { double('ProductOffer', product_id: 1, minimum_quantity: 1, new_price: 0.000) }

  describe '#adapt' do
    let(:product) { item }

    before :each do
      allow(Product).to receive(:find_by).with(code: green_tea_product.code).and_return(green_tea_product)
      allow_any_instance_of(Product).to receive(:product_offer).and_return(product_offer)
    end

    context 'no green tea in the order' do
      let(:coffee_order) { double('Order', order_lines: [item_coffee]) }

      it 'must not be modified due to no green tea in the order' do
        expect(described_class.adapt(coffee_order).to_json).to eq(coffee_order.to_json)
      end
    end

    context 'one green tea added' do
      let(:just_one_green_tea_order) { double('Order', order_lines: [item_green_tea]) }
      let(:one_green_tea_for_free) { double('Order', order_lines: [item_green_tea, item_green_tea_for_free]) }
      let(:two_green_tea_order) { double('Order', order_lines: [item_green_tea, item_green_tea]) }
      let(:two_green_tea_for_free) {  double('Order', order_lines: [item_green_tea, item_green_tea, item_green_tea_for_free, item_green_tea_for_free]) }

      it 'must add an extra green tea for free' do
        expect(described_class.adapt(just_one_green_tea_order).to_json).to eq(one_green_tea_for_free.to_json)
      end

      it 'must add two extra green tea for free' do
        expect(described_class.adapt(two_green_tea_order).to_json).to eq(two_green_tea_for_free.to_json)
      end
    end
  end

  describe '#adapt' do
    context 'Free green tea has been removed.'do
      let(:one_green_tea_order) { double('Order', order_lines: [item_green_tea_for_free]) }

      it 'must contain no green tea at all' do
        expect(described_class.correct(one_green_tea_order).order_lines.size).to eq(0)
      end
    end

    context 'Paid green tea has been removed.'do
      let(:one_green_tea_order) { double('Order', order_lines: [item_green_tea]) }

      it 'must contain no green tea at all' do
        expect(described_class.correct(one_green_tea_order).order_lines.size).to eq(0)
      end
    end
  end


end

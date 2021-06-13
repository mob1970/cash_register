# frozen_string_literal: true

require 'rails_helper'
require './lib/order_adapter/base'
require './lib/order_adapter/green_tea_for_free'

describe OrderAdapter::GreenTeaForFree do
  let(:green_tea_product) { Product.new(code: 'GR1', name: 'Green Tea', price: 3.11) }
  let(:coffee_product) { Product.new(code: 'CF1', name: 'Coffee', price: 10.00) }
  let(:item_green_tea) { double('Green Tea', product: green_tea_product, price: 3.11) }
  let(:item_green_tea_for_free) { double('Green Tea', product: green_tea_product, price: 0.00) }
  let(:item_coffee) { OrderLine.new(product: coffee_product, price: 10.00) }
  let(:item) { item_coffee }
  let(:order) { double('Order') }

  describe '#handles?' do
    context 'product is not green tea' do
      let(:other_product) { double('Product', code: 'FF1') }

      it 'returns false' do
        expect(described_class.handles?(other_product)).to be_falsey
      end
    end

    context 'product is green tea' do
      let(:green_tea_product) { double('Product', code: 'GR1') }

      it 'returns true' do
        expect(described_class.handles?(green_tea_product)).to be_truthy
      end
    end
  end

  describe '#adapt' do
    let(:product) { item }

    before :each do
      allow(Product).to receive(:find_by).with(code: green_tea_product.code).and_return(green_tea_product)
    end

    context 'no green tea in the order' do
      let(:coffee_order) { double('Order', order_lines: [item_coffee]) }

      it 'must not be modified due to no green tea in the order' do
        expect(subject.adapt(green_tea_product, coffee_order).to_json).to eq(coffee_order.to_json)
      end
    end

    context 'one green tea added' do
      let(:just_one_green_tea_order) { double('Order', order_lines: [item_green_tea]) }
      let(:one_green_tea_for_free) {  double('Order', order_lines: [item_green_tea, item_green_tea_for_free]) }
      let(:two_green_tea_order) { double('Order', order_lines: [item_green_tea, item_green_tea]) }
      let(:two_green_tea_for_free) {  double('Order', order_lines: [item_green_tea, item_green_tea, item_green_tea_for_free, item_green_tea_for_free]) }

      it 'must add an extra green tea for free' do
        expect(subject.adapt(green_tea_product, just_one_green_tea_order).to_json).to eq(one_green_tea_for_free.to_json)
      end

      it 'must add two extra green tea for free' do
        expect(subject.adapt(green_tea_product, two_green_tea_order).to_json).to eq(two_green_tea_for_free.to_json)
      end
    end
  end
end

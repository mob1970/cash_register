# frozen_string_literal: true

require 'rails_helper'
require './lib/order_promotions/base'
require './lib/order_promotions/strawberries_addict_discount'

describe OrderPromotions::StrawberriesAddictDiscount do
  let(:strawberry_product) { Product.new(code: 'SR1', name: 'Strawberry', price: 5.00) }
  let(:item_strawberry) { OrderLine.new(product: strawberry_product, price: 5.00) }
  let(:new_price) { 4.50 }
  let(:item_strawberry_modified) { OrderLine.new(product: strawberry_product, price: new_price) }
  let(:item) { item_strawberry }
  let(:order) { double('Order') }

  describe '#adapt' do
    let(:product) { item }

    before :each do
      allow(Product).to receive(:find_by).with(code: strawberry_product.code).and_return(strawberry_product)
    end

    context 'price changed' do
      let(:three_strawberry_order) { double('Order', order_lines: [item_strawberry, item_strawberry, item_strawberry]) }
      let(:three_strawberry_order_modified) { double('Order', order_lines: [item_strawberry_modified, item_strawberry_modified, item_strawberry_modified]) }

      it 'must apply the new price with three or more strawberries' do
        expect(described_class.adapt(three_strawberry_order).to_json).to eq(three_strawberry_order_modified.to_json)
      end
    end

    context 'new price not applied' do
      let(:just_one_strawberry_order) { double('Order', order_lines: [item_strawberry]) }
      let(:just_two_strawberry_order) {  double('Order', order_lines: [item_strawberry, item_strawberry]) }

      it 'must not apply the new price' do
        expect(described_class.adapt(just_one_strawberry_order)).to eq(just_one_strawberry_order)
      end

      it 'must not apply the new price with two strawberries' do
        expect(described_class.adapt(just_two_strawberry_order)).to eq(just_two_strawberry_order)
      end
    end
  end

  describe '#adapt' do
    let(:item_strawberry) { OrderLine.new(product: strawberry_product, price: 5.00) }
    let(:just_one_strawberry_order) { double('Order', order_lines: [item_strawberry]) }

    it 'must return the order unmodified' do
      expect(described_class.correct(just_one_strawberry_order)).to eq(just_one_strawberry_order)
    end
  end
end

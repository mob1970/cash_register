# frozen_string_literal: true

require 'rails_helper'
require './lib/order_adapter/base'
require './lib/order_adapter/default'

describe OrderAdapter::Default do
  let(:item) { double('Item', code: 'foo', price: 10.00) }
  let(:order) { double('Order') }

  describe '#price' do
    let(:product) { item }

    before :each do
      allow(Product).to receive(:find_by).with(code: item.code).and_return(product)
    end

    context 'product exists' do
      it 'must not raise a NotImplementedException error' do
        expect(subject.adapt(item, order)).to eq(order)
      end
    end
  end
end


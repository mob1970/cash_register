# frozen_string_literal: true

require 'rails_helper'

describe Order, type: :model do
  let(:product_foo) { Product.new(code: 1, name: 'foo', price: 15.00) }
  let(:product_bar) { Product.new(code: 2, name: 'bar', price: 5.00) }
  let(:order_lines) do
    [
      OrderLine.new(id: 1, product: product_foo, price: 15.00),
      OrderLine.new(id: 2, product: product_bar, price: 5.00)
    ]
  end

  subject { described_class.new(id: 1, name: 'Foo Product', order_lines: order_lines, total_amount: 20.00) }

  describe 'validations' do
    context 'name' do
      it 'must be valid if name is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if order_id is not set' do
        subject.name = nil
        expect(subject.valid?).to be_falsey
      end
    end

    context 'total_amount' do
      it 'must be valid if total_amount is bigger than 0' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if order_id is not set' do
        subject.total_amount = nil
        expect(subject.valid?).to be_falsey
      end

      it 'must be valid if order_id is equal to zero' do
        subject.total_amount = 0
        expect(subject.valid?).to be_truthy
      end
    end
  end
end

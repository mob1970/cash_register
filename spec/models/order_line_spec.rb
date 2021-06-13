require 'rails_helper'

describe OrderLine, type: :model do
  let(:product) { Product.new(id: 1, code: 2, name: 'foo product', price: 10) }
  let(:order) { Order.new(id: 1, name: 'foo', total_amount: 10) }

  subject { described_class.new(order: order, product: product, price: 2) }

  describe 'validations' do
    context 'order' do
      it 'must be valid if order_id is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if order_id is not set' do
        subject.order = nil
        expect(subject.valid?).to be_falsey
      end
    end

    context 'product' do
      it 'must be valid if order_id is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if order_id is not set' do
        subject.product = nil
        expect(subject.valid?).to be_falsey
      end
    end

    context 'price' do
      it 'must be valid if price is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if price is set to 0' do
        subject.price = 0
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if price is not set' do
        subject.price = nil
        expect(subject.valid?).to be_falsey
      end
    end
  end
end

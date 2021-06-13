# frozen_string_literal: true

require 'rails_helper'

describe Product, type: :model do
  subject { Product.new(code: 'MJ23', name: 'Foo Name', price: 25.00) }

  describe 'validations' do
    context 'code' do
      it 'must be valid if the code is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if the code is not set' do
        subject.code = nil
        expect(subject.valid?).to be_falsey
      end
    end

    context 'name' do
      it 'must be valid if the name is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if the name is not set' do
        subject.name = nil
        expect(subject.valid?).to be_falsey
      end
    end

    context 'price' do
      it 'must be valid if the price is set' do
        expect(subject.valid?).to be_truthy
      end

      it 'must not be valid if the price is not set' do
        subject.price = nil
        expect(subject.valid?).to be_falsey
      end

      it 'must not be valid if the price is set to zero' do
        subject.price = 0
        expect(subject.valid?).to be_falsey
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require './lib/order_promotions/base'

describe OrderPromotions::Base do
  let(:item) { double('Item', code: 'foo', price: 10.00) }
  let(:order) { double('Order') }

  class MethodPriceNotOverridenClass < OrderPromotions::Base; end
  class MethodPriceOverridenClass < OrderPromotions::Base
    def self.adapt(_item, _order)
      5
    end
  end

  describe '#adapt' do
    let(:product) { item }

    before :each do
      allow(Product).to receive(:find_by).with(code: item.code).and_return(product)
    end

    context 'method not overriden' do
      it 'must raise a NotImplementedError' do
        expect { MethodPriceNotOverridenClass.adapt(order) }.to raise_exception(NotImplementedError)
      end
    end

    context 'method overriden' do
      it 'must not raise a NotImplementedException error' do
        expect { MethodPriceOverridenClass.adapt(order) }.not_to raise_exception(NotImplementedError)
      end
    end
  end
end

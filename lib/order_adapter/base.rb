# frozen_string_literal: true

require './lib/order_adapter/order_adapter'

module OrderAdapter
  class ProductNotFoundError < StandardError; end
  class IncorrectProductError < StandardError; end

  # Base class for all the price handlers
  class Base
    def self.register(handler)
      OrderAdapter.register self, handler
    end

    def adapt(_item, _order)
      raise NotImplementedError, "Method adapt must be overriden in class #{self.class}"
    end
  end
end

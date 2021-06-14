# frozen_string_literal: true

require './lib/order_promotions/order_promotions_handler'

module OrderPromotions
  # Base class for all the price handlers
  class Base
    def self.register(handler)
      OrderPromotions::OrderPromotionsHandler.register self, handler
    end

    def self.adapt(_order)
      raise NotImplementedError, "Method adapt must be overriden in class #{self.class}"
    end
  end
end

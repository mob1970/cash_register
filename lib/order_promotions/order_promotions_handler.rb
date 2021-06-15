# frozen_string_literal: true

module OrderPromotions
  # Class to controll all the order adapters
  class OrderPromotionsHandler
    @@promotions = {}

    def self.register(klass, handler)
      @@promotions[handler] = klass
    end

    def self.apply(order)
      @@promotions.values.each do |klass|
        order = klass.adapt(order)
      end

      order
    end
  end
end

# frozen_string_literal: true

module OrderPromotions
  # Class to controll all the order adapters
  class OrderPromotionsHandler
    @@adapters = {}

    def self.register(klass, handler)
      @@adapters[handler] = klass
    end

    def self.apply(order)
      @@adapters.values.each do |klass|
        order = klass.adapt(order)
      end

      order
    end
  end
end

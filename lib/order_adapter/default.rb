# frozen_string_literal: true

module OrderAdapter
  # Default handler for OrderAdapter
  class Default < Base
    default = self

    def adapt(_item, order)
      order
    end
  end
end

# frozen_string_literal: true

require 'handler_registerable'

# Module for all the price handlers to implement the handler pattern
module OrderAdapter
  extend HandlerRegisterable::Registry
end

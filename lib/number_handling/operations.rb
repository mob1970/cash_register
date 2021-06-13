module NumberHandling
  class Operations
    class << self
      def convert_to_decimals(amount, decimals)
        return 0 unless amount

        amount.to_d.truncate(decimals)
      end
    end
  end
end

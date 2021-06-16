module OrdersHelper
  def convert_to_decimals(amount, decimals)
    NumberHandling::Operations.convert_to_decimals(amount, decimals)
  end
end

require 'rails_helper'

RSpec.describe "order_lines/show", type: :view do
  before(:each) do
    @order_line = assign(:order_line, OrderLine.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

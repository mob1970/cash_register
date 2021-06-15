require 'rails_helper'

RSpec.describe "order_lines/index", type: :view do
  before(:each) do
    assign(:order_lines, [
      OrderLine.create!(),
      OrderLine.create!()
    ])
  end

  it "renders a list of order_lines" do
    render
  end
end

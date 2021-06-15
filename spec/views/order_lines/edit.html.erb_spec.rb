require 'rails_helper'

RSpec.describe "order_lines/edit", type: :view do
  before(:each) do
    @order_line = assign(:order_line, OrderLine.create!())
  end

  it "renders the edit order_line form" do
    render

    assert_select "form[action=?][method=?]", order_line_path(@order_line), "post" do
    end
  end
end

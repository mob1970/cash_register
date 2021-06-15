require 'rails_helper'

RSpec.describe "order_lines/new", type: :view do
  before(:each) do
    assign(:order_line, OrderLine.new())
  end

  it "renders new order_line form" do
    render

    assert_select "form[action=?][method=?]", order_lines_path, "post" do
    end
  end
end

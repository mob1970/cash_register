require './lib/number_handling/operations'
require './lib/order_promotions/order_promotions'

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
    @products = Product.all
    @order = Order.includes(:order_lines).joins(:order_lines)
      .joins('INNER JOIN products ON products.id = order_lines.product_id')
      .includes(:products).find(params['id'])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @order.total_amount = 0

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    add_new_product_to_order if new_product_sent?
    delete_order_line_in_order if order_line_to_remove_sent?
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:name)
  end

  def new_product_sent?
    return false unless params['order']
    return false unless params['order']['product_id'].present?

    true
  end

  def order_line_to_remove_sent?
    return false unless params['order']
    return false unless params['order']['order_line_to_remove'].present?

    true
  end

  def add_new_product_to_order
    product = Product.find(params['order']['product_id'])
    @order.order_lines << OrderLine.new(product_id: product.id, price: product.price)
    recalculate_order
  end

  def delete_order_line_in_order
    order_line_id = OrderLine.find(params['order']['order_line_to_remove'])
    @order.order_lines.delete(order_line_id)
    @order = OrderPromotions::OrderPromotionsHandler.adjust(@order)
    recalculate_order
  end

  def recalculate_order
    @order = OrderPromotions::OrderPromotionsHandler.apply(@order)
    @order.total_amount = @order.order_lines.sum(&:price).ceil(2)
  end
end

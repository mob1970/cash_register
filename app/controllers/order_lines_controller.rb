class OrderLinesController < ApplicationController
  before_action :set_order_line, only: %i[ show edit update destroy ]

  # GET /order_lines or /order_lines.json
  def index
    @order_lines = OrderLine.where(order_id: params['order_id'])
  end

  # GET /order_lines/1 or /order_lines/1.json
  def show
  end

  # GET /order_lines/new
  def new
    @order_id = params['order_id']
    @products = Product.all
    @order_line = OrderLine.new
  end

  # GET /order_lines/1/edit
  def edit
  end

  # POST /order_lines or /order_lines.json
  def create
    @order_line = OrderLine.new(order_line_params)
    product = Product.find(@order_line.product_id)
    @order_line.price = product.price

    respond_to do |format|
      if @order_line.save
        format.html { redirect_to @order_line.order, notice: "Order was successfully updated." }
      else
        format.html { redirect_to @order_line.order, status: :unprocessable_entity }
        format.json { render json: @order_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_lines/1 or /order_lines/1.json
  def update
    respond_to do |format|
      if @order_line.update(order_line_params)
        format.html { redirect_to @order_line, notice: "Order line was successfully updated." }
        format.json { render :show, status: :ok, location: @order_line }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_lines/1 or /order_lines/1.json
  def destroy
    @order_line.destroy
    respond_to do |format|
      format.html { redirect_to order_lines_url, notice: "Order line was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_line
      @order_line = OrderLine.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_line_params
      params.fetch(:order_line, {})
      params.require(:order_line).permit(:order_id, :product_id, :price)
    end
end

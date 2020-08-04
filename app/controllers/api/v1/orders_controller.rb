class Api::V1::OrdersController < ApplicationController

  def index
    @order = Order.all
    render json: { status: "#{@order.size} orders found.", orders: @order }, status: :ok
  end

  def show
    @order = Order.where_order_join_state(params[:id].to_i, params[:state_id].to_i)

    if @order
      render json: { status: 'Order found.', orders: @order }, status: :ok
    else
      render json: { errors: 'Order not found.', orders: [] }, status: :ok
    end

  end

  def create
    @order = Order.new(state_id: 1)

    if @order.save
      render json: { status: 'Order created successfully.', order: @order }, status: :created
    else
      render json: { errors: order.errors.full_messages[0] }, status: :bad_request
    end
  end

  def update
    @order = Order.find(params[:id])

    actual_state = @order[:state_id].to_i
    new_state = actual_state + 1

    if actual_state === 1 || actual_state === 2
      if @order.update state_id: new_state
        order = Order.where_order_join_state(params[:id].to_i, new_state.to_i)
        render json: { status: 'Order updated successfully.', order: order }, status: :ok
      else
        render json: { errors: order.errors.full_messages[0], order: [] }, status: :bad_request
      end
    else
      render json: { errors: "Order could not be updated.", order: [] }, status: :bad_request
    end

  end

  def states
    @states = State.all.order(:id)
    render json: { status: 'Successfully.', states: @states }, status: :ok
  end

  private

  def order_params
    params.require(:order).permit(:state_id)
  end

end

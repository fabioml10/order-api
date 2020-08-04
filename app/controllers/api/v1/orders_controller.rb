class Api::V1::OrdersController < ApplicationController

  def index
    @order = Order.where_order_join_state
    render json: { status: "#{@order.size} orders found.", order: @order }, status: :ok
  end

  def show
    @order = Order.find_order_join_state(params[:id])

    if @order
      render json: { status: 'Order found.', order: @order }, status: :ok
    else
      render json: { errors: 'Order not found.' }, status: :not_found
    end

  end

  def create

    if order_params[:state_id].to_i === 1
      @order = Order.new(order_params)

      if @order.save
        render json: { status: 'Order created successfully.', order: @order }, status: :created
      else
        render json: { errors: user.errors.full_messages[0] }, status: :bad_request
      end
    else
      render json: { errors: "An order can only be created with a pending state." }, status: :bad_request
    end

  end

  def update
    @order = Order.find(params[:id])
    actual_state = @order['state_id'].to_i
    new_state = order_params[:state_id].to_i

    if is_workflow_rigth?(actual_state, new_state)
      if @order.update state_id: new_state
      order = Order.find_order_join_state(params[:id])
        render json: { status: 'Order updated successfully.', order: order }, status: :ok
      else
        render json: { errors: user.errors.full_messages[0] }, status: :bad_request
      end
    else
      render json: { errors: "Order could not be updated." }, status: :bad_request
    end

  end

  def state
    @order = Order.where_order_join_state(params[:state_id].to_i)

    unless @order.blank?
      render json: { status: 'Orders found.', order: @order }, status: :ok
    else
      render json: { errors: 'Orders not found.' }, status: :not_found
    end

  end

  private

  def order_params
    params.require(:order).permit(:state_id)
  end

  def is_workflow_rigth?(actual_state, new_state)
    (actual_state === 1 && new_state === 2) || (actual_state === 2 && new_state === 3)
  end

end

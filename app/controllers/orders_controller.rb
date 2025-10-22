# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :require_login

  # 注文一覧
  def index
    service = Application::Order::GetOrdersService.new
    @orders_with_items = service.execute(user_id: current_user.id.value)
  end

  # 注文作成
  def create
    service = Application::Order::CreateOrderService.new

    begin
      service.execute(user_id: current_user.id.value)
      flash[:notice] = '注文が完了しました'
      redirect_to orders_path
    rescue ArgumentError => e
      flash[:alert] = e.message
      redirect_to cart_items_path
    end
  end
end


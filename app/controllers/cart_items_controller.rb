# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :require_login

  # カート表示
  def index
    service = Application::CartAggregate::GetCartService.new
    result = service.execute(user_id: current_user.id.value)
    
    @cart_items = result[:cart_items]
    @products = result[:products]
    @total = result[:total]
  end

  # カートに追加
  def create
    service = Application::CartAggregate::AddToCartService.new

    begin
      service.execute(
        user_id: current_user.id.value,
        product_id: params[:product_id],
        quantity: params[:quantity].to_i
      )

      flash[:notice] = 'カートに追加しました'
      redirect_to cart_items_path
    rescue ArgumentError => e
      flash[:alert] = e.message
      redirect_to products_path
    end
  end

  # カートから削除
  def destroy
    service = Application::CartAggregate::RemoveFromCartService.new

    begin
      service.execute(cart_item_id: params[:id])
      flash[:notice] = 'カートから削除しました'
    rescue ArgumentError => e
      flash[:alert] = e.message
    end

    redirect_to cart_items_path
  end
end


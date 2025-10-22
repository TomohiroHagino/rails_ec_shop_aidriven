# frozen_string_literal: true

class ProductsController < ApplicationController
  # 商品一覧
  def index
    service = Application::ProductAggregate::ListProductsService.new
    @products = service.execute_in_stock
  end

  # 商品詳細
  def show
    service = Application::ProductAggregate::GetProductService.new
    
    begin
      @product = service.execute(product_id: params[:id])
    rescue ArgumentError => e
      flash[:alert] = e.message
      redirect_to products_path
    end
  end
end


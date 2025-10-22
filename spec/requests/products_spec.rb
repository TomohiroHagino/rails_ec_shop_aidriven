# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let!(:product1) { create(:product, name: '商品1', stock_quantity: 10) }
  let!(:product2) { create(:product, name: '商品2', stock_quantity: 0) }

  describe 'GET /products' do
    it '商品一覧ページが表示される' do
      get products_path
      expect(response).to have_http_status(:success)
    end

    it '在庫のある商品のみ表示される' do
      get products_path
      expect(response.body).to include('商品1')
      expect(response.body).not_to include('商品2')
    end
  end

  describe 'GET /products/:id' do
    it '商品詳細ページが表示される' do
      get product_path(product1)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('商品1')
    end

    context '存在しない商品の場合' do
      it '商品一覧にリダイレクトされる' do
        get product_path(id: 99999)
        expect(response).to redirect_to(products_path)
      end
    end
  end
end


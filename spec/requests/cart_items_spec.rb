# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CartItems', type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product, stock_quantity: 10) }

  before do
    # ログイン（Warden）
    login_as(user, scope: :user)
  end

  describe 'GET /cart_items' do
    it 'カートページが表示される' do
      get cart_items_path
      expect(response).to have_http_status(:success)
    end

    context 'ログインしていない場合' do
      before { sign_out :user }

      it 'ログインページにリダイレクトされる' do
        get cart_items_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /cart_items' do
    it 'カートに商品を追加できる' do
      expect do
        post cart_items_path, params: {
          product_id: product.id,
          quantity: 2
        }
      end.to change(CartItem, :count).by(1)
    end

    it 'カートページにリダイレクトされる' do
      post cart_items_path, params: {
        product_id: product.id,
        quantity: 2
      }
      expect(response).to redirect_to(cart_items_path)
    end

    context '在庫が不足している場合' do
      it 'エラーメッセージが表示される' do
        post cart_items_path, params: {
          product_id: product.id,
          quantity: 11
        }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE /cart_items/:id' do
    let!(:cart_item) { create(:cart_item, user: user, product: product) }

    it 'カートから商品を削除できる' do
      expect do
        delete cart_item_path(cart_item)
      end.to change(CartItem, :count).by(-1)
    end

    it 'カートページにリダイレクトされる' do
      delete cart_item_path(cart_item)
      expect(response).to redirect_to(cart_items_path)
    end
  end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: 1000, stock_quantity: 10) }

  before do
    # ログイン（Warden）
    login_as(user, scope: :user)
  end

  describe 'GET /orders' do
    it '注文履歴ページが表示される' do
      get orders_path
      expect(response).to have_http_status(:success)
    end

    context 'ログインしていない場合' do
      before { sign_out :user }

      it 'ログインページにリダイレクトされる' do
        get orders_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /orders' do
    before do
      create(:cart_item, user: user, product: product, quantity: 2)
    end

    it '注文が作成される' do
      expect do
        post orders_path
      end.to change(Order, :count).by(1)
    end

    it '注文履歴ページにリダイレクトされる' do
      post orders_path
      expect(response).to redirect_to(orders_path)
    end

    it 'カートがクリアされる' do
      post orders_path
      expect(CartItem.where(user: user).count).to eq(0)
    end

    context 'カートが空の場合' do
      before { CartItem.where(user: user).destroy_all }

      it 'エラーメッセージが表示される' do
        post orders_path
        expect(flash[:alert]).to be_present
      end

      it 'カートページにリダイレクトされる' do
        post orders_path
        expect(response).to redirect_to(cart_items_path)
      end
    end
  end
end


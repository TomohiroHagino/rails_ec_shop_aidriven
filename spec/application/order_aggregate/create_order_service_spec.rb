# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::OrderAggregate::CreateOrderService do
  let(:service) { described_class.new }
  let(:user) { create(:user) }
  let(:product1) { create(:product, price: 1000, stock_quantity: 10) }
  let(:product2) { create(:product, price: 2000, stock_quantity: 5) }

  describe '#execute' do
    context '正常に注文を作成する場合' do
      before do
        create(:cart_item, user: user, product: product1, quantity: 2)
        create(:cart_item, user: user, product: product2, quantity: 1)
      end

      it '注文が作成される' do
        expect do
          service.execute(user_id: user.id)
        end.to change(Order, :count).by(1)
      end

      it '注文アイテムが作成される' do
        expect do
          service.execute(user_id: user.id)
        end.to change(OrderItem, :count).by(2)
      end

      it '合計金額が正しく計算される' do
        order = service.execute(user_id: user.id)
        expect(order.total_amount.to_i).to eq(4000) # 1000*2 + 2000*1
      end

      it 'カートがクリアされる' do
        service.execute(user_id: user.id)
        expect(CartItem.where(user: user).count).to eq(0)
      end

      it '在庫が減る' do
        expect do
          service.execute(user_id: user.id)
        end.to change { product1.reload.stock_quantity }.by(-2)
          .and change { product2.reload.stock_quantity }.by(-1)
      end
    end

    context 'カートが空の場合' do
      it 'エラーが発生する' do
        expect do
          service.execute(user_id: user.id)
        end.to raise_error(ArgumentError, 'カートが空です')
      end
    end

    context '在庫が不足している場合' do
      before do
        create(:cart_item, user: user, product: product1, quantity: 11)
      end

      it 'エラーが発生する' do
        expect do
          service.execute(user_id: user.id)
        end.to raise_error(ArgumentError, /在庫が不足しています/)
      end

      it '注文が作成されない' do
        expect do
          begin
            service.execute(user_id: user.id)
          rescue ArgumentError
            # エラーを無視
          end
        end.not_to change(Order, :count)
      end
    end
  end
end


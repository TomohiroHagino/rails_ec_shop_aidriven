# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::CartAggregate::AddToCartService do
  let(:service) { described_class.new }
  let(:user) { create(:user) }
  let(:product) { create(:product, stock_quantity: 10) }

  describe '#execute' do
    context '正常にカートに追加する場合' do
      it 'カートアイテムが作成される' do
        expect do
          service.execute(
            user_id: user.id,
            product_id: product.id,
            quantity: 2
          )
        end.to change(CartItem, :count).by(1)
      end

      it '指定した数量でカートアイテムが作成される' do
        service.execute(
          user_id: user.id,
          product_id: product.id,
          quantity: 3
        )

        cart_item = CartItem.last
        expect(cart_item.quantity).to eq(3)
      end
    end

    context '既にカートに同じ商品がある場合' do
      before do
        create(:cart_item, user: user, product: product, quantity: 2)
      end

      it '数量が追加される' do
        expect do
          service.execute(
            user_id: user.id,
            product_id: product.id,
            quantity: 3
          )
        end.not_to change(CartItem, :count)

        cart_item = CartItem.find_by(user: user, product: product)
        expect(cart_item.quantity).to eq(5)
      end
    end

    context '在庫が不足している場合' do
      it 'エラーが発生する' do
        expect do
          service.execute(
            user_id: user.id,
            product_id: product.id,
            quantity: 11
          )
        end.to raise_error(ArgumentError, '在庫が不足しています')
      end
    end

    context '存在しない商品の場合' do
      it 'エラーが発生する' do
        expect do
          service.execute(
            user_id: user.id,
            product_id: 99999,
            quantity: 1
          )
        end.to raise_error(ArgumentError, '商品が見つかりません')
      end
    end
  end
end


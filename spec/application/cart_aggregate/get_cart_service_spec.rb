# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::CartAggregate::GetCartService do
  let(:cart_repository) { double('CartRepository') }
  let(:product_repository) { double('ProductRepository') }
  let(:service) { described_class.new(cart_repository: cart_repository, product_repository: product_repository) }
  let(:user) { create(:user) }
  let(:product) { create(:product, price: 1000) }

  describe '#execute' do
    context 'カートにアイテムがある場合' do
      let(:cart_item) do
        Domain::CartAggregate::Entity::CartItemEntity.new(
          id: Domain::CartAggregate::ValueObject::CartItemId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          product_id: Domain::ProductAggregate::ValueObject::ProductId.new(product.id),
          quantity: 2
        )
      end

      let(:product_entity) do
        Domain::ProductAggregate::Entity::ProductEntity.new(
          id: Domain::ProductAggregate::ValueObject::ProductId.new(product.id),
          name: product.name,
          description: product.description,
          price: Domain::ProductAggregate::ValueObject::Price.new(product.price),
          stock_quantity: product.stock_quantity
        )
      end

      before do
        allow(cart_repository).to receive(:find_by_user_id).and_return([cart_item])
        allow(product_repository).to receive(:find).and_return(product_entity)
      end

      it 'カート情報を正しく取得できる' do
        result = service.execute(user_id: user.id)

        expect(result[:cart_items]).to eq([cart_item])
        expect(result[:products]).to eq({ product.id => product_entity })
        expect(result[:total]).to eq(BigDecimal('2000'))
      end

      it '商品情報も含めて取得できる' do
        result = service.execute(user_id: user.id)

        expect(result[:products][product.id]).to eq(product_entity)
      end

      it '合計金額が正しく計算される' do
        result = service.execute(user_id: user.id)

        expect(result[:total]).to eq(BigDecimal('2000')) # 1000 * 2
      end
    end

    context 'カートが空の場合' do
      before do
        allow(cart_repository).to receive(:find_by_user_id).and_return([])
      end

      it '空のカート情報を返す' do
        result = service.execute(user_id: user.id)

        expect(result[:cart_items]).to eq([])
        expect(result[:products]).to eq({})
        expect(result[:total]).to eq(BigDecimal('0'))
      end
    end

    context '商品が見つからない場合' do
      let(:cart_item) do
        Domain::CartAggregate::Entity::CartItemEntity.new(
          id: Domain::CartAggregate::ValueObject::CartItemId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          product_id: Domain::ProductAggregate::ValueObject::ProductId.new(999),
          quantity: 1
        )
      end

      before do
        allow(cart_repository).to receive(:find_by_user_id).and_return([cart_item])
        allow(product_repository).to receive(:find).and_return(nil)
      end

      it '商品が見つからなくてもエラーにならない' do
        result = service.execute(user_id: user.id)

        expect(result[:cart_items]).to eq([cart_item])
        expect(result[:products]).to eq({ 999 => nil })
        expect(result[:total]).to eq(BigDecimal('0'))
      end
    end

    context '複数のカートアイテムがある場合' do
      let(:product2) { create(:product, price: 500) }
      let(:cart_item1) do
        Domain::CartAggregate::Entity::CartItemEntity.new(
          id: Domain::CartAggregate::ValueObject::CartItemId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          product_id: Domain::ProductAggregate::ValueObject::ProductId.new(product.id),
          quantity: 2
        )
      end

      let(:cart_item2) do
        Domain::CartAggregate::Entity::CartItemEntity.new(
          id: Domain::CartAggregate::ValueObject::CartItemId.new(2),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          product_id: Domain::ProductAggregate::ValueObject::ProductId.new(product2.id),
          quantity: 3
        )
      end

      let(:product_entity1) do
        Domain::ProductAggregate::Entity::ProductEntity.new(
          id: Domain::ProductAggregate::ValueObject::ProductId.new(product.id),
          name: product.name,
          description: product.description,
          price: Domain::ProductAggregate::ValueObject::Price.new(product.price),
          stock_quantity: product.stock_quantity
        )
      end

      let(:product_entity2) do
        Domain::ProductAggregate::Entity::ProductEntity.new(
          id: Domain::ProductAggregate::ValueObject::ProductId.new(product2.id),
          name: product2.name,
          description: product2.description,
          price: Domain::ProductAggregate::ValueObject::Price.new(product2.price),
          stock_quantity: product2.stock_quantity
        )
      end

      before do
        allow(cart_repository).to receive(:find_by_user_id).and_return([cart_item1, cart_item2])
        allow(product_repository).to receive(:find).with(cart_item1.product_id).and_return(product_entity1)
        allow(product_repository).to receive(:find).with(cart_item2.product_id).and_return(product_entity2)
      end

      it '複数の商品の合計金額が正しく計算される' do
        result = service.execute(user_id: user.id)

        expect(result[:total]).to eq(BigDecimal('3500')) # (1000 * 2) + (500 * 3)
      end

      it 'すべての商品情報が取得される' do
        result = service.execute(user_id: user.id)

        expect(result[:products]).to eq({
          product.id => product_entity1,
          product2.id => product_entity2
        })
      end
    end
  end
end

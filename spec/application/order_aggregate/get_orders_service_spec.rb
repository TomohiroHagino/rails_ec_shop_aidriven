# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::OrderAggregate::GetOrdersService do
  let(:order_repository) { double('OrderRepository') }
  let(:product_repository) { double('ProductRepository') }
  let(:service) { described_class.new(order_repository: order_repository, product_repository: product_repository) }
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe '#execute' do
    context '正常に注文一覧を取得する場合' do
      let(:order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: Time.current
        )
      end

      let(:order_item) do
        Domain::OrderAggregate::Entity::OrderItemEntity.new(
          id: 1,
          order_id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          product_id: Domain::ProductAggregate::ValueObject::ProductId.new(product.id),
          quantity: 2,
          price: Domain::ProductAggregate::ValueObject::Price.new(500)
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
        allow(order_repository).to receive(:find_by_user_id).and_return([order])
        allow(order_repository).to receive(:find_items_by_order_id).and_return([order_item])
        allow(product_repository).to receive(:find).and_return(product_entity)
      end

      it '注文一覧を正しく取得できる' do
        result = service.execute(user_id: user.id)

        expect(result).to be_an(Array)
        expect(result.length).to eq(1)
        expect(result.first[:order]).to eq(order)
      end

      it '注文アイテムと商品情報が含まれる' do
        result = service.execute(user_id: user.id)

        order_data = result.first
        expect(order_data[:items]).to be_an(Array)
        expect(order_data[:items].first[:order_item]).to eq(order_item)
        expect(order_data[:items].first[:product]).to eq(product_entity)
      end

      it 'UserIdのValueObjectが正しく作成される' do
        service.execute(user_id: 123)

        expect(order_repository).to have_received(:find_by_user_id).with(
          Domain::UserAggregate::ValueObject::UserId.new(123)
        )
      end
    end

    context '注文がない場合' do
      before do
        allow(order_repository).to receive(:find_by_user_id).and_return([])
      end

      it '空の配列を返す' do
        result = service.execute(user_id: user.id)

        expect(result).to eq([])
      end
    end

    context '注文アイテムがない場合' do
      let(:order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(0),
          created_at: Time.current
        )
      end

      before do
        allow(order_repository).to receive(:find_by_user_id).and_return([order])
        allow(order_repository).to receive(:find_items_by_order_id).and_return([])
      end

      it '空のアイテム配列を返す' do
        result = service.execute(user_id: user.id)

        expect(result.first[:items]).to eq([])
      end
    end

    context '商品が見つからない場合' do
      let(:order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: Time.current
        )
      end

      let(:order_item) do
        Domain::OrderAggregate::Entity::OrderItemEntity.new(
          id: 1,
          order_id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          product_id: Domain::ProductAggregate::ValueObject::ProductId.new(999),
          quantity: 1,
          price: Domain::ProductAggregate::ValueObject::Price.new(1000)
        )
      end

      before do
        allow(order_repository).to receive(:find_by_user_id).and_return([order])
        allow(order_repository).to receive(:find_items_by_order_id).and_return([order_item])
        allow(product_repository).to receive(:find).and_return(nil)
      end

      it '商品が見つからなくてもエラーにならない' do
        result = service.execute(user_id: user.id)

        expect(result.first[:items].first[:product]).to be_nil
      end
    end

    context '複数の注文がある場合' do
      let(:order1) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 1.day.ago
        )
      end

      let(:order2) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(2),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('confirmed'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(2000),
          created_at: Time.current
        )
      end

      before do
        allow(order_repository).to receive(:find_by_user_id).and_return([order1, order2])
        allow(order_repository).to receive(:find_items_by_order_id).and_return([])
      end

      it '複数の注文を正しく取得できる' do
        result = service.execute(user_id: user.id)

        expect(result.length).to eq(2)
        expect(result.map { |r| r[:order] }).to eq([order1, order2])
      end
    end

    context 'リポジトリでエラーが発生した場合' do
      before do
        allow(order_repository).to receive(:find_by_user_id).and_raise(StandardError, 'Database error')
      end

      it 'エラーが再発生する' do
        expect { service.execute(user_id: user.id) }.to raise_error(StandardError, 'Database error')
      end
    end
  end
end

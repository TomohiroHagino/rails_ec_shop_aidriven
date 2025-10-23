# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::ProductAggregate::GetProductService do
  let(:product_repository) { double('ProductRepository') }
  let(:service) { described_class.new(product_repository: product_repository) }
  let(:product) { create(:product) }

  describe '#execute' do
    context '正常に商品を取得する場合' do
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
        allow(product_repository).to receive(:find).and_return(product_entity)
      end

      it '商品エンティティを返す' do
        result = service.execute(product_id: product.id)

        expect(result).to eq(product_entity)
      end

      it 'ProductIdのValueObjectが正しく作成される' do
        service.execute(product_id: 123)

        expect(product_repository).to have_received(:find).with(
          Domain::ProductAggregate::ValueObject::ProductId.new(123)
        )
      end

      it '商品の詳細情報が正しく取得される' do
        result = service.execute(product_id: product.id)

        expect(result.id.value).to eq(product.id)
        expect(result.name).to eq(product.name)
        expect(result.price.value).to eq(product.price)
      end
    end

    context '商品が見つからない場合' do
      before do
        allow(product_repository).to receive(:find).and_return(nil)
      end

      it 'ArgumentErrorが発生する' do
        expect { service.execute(product_id: 999) }.to raise_error(
          ArgumentError, '商品が見つかりません'
        )
      end

      it '存在しないIDでエラーが発生する' do
        expect { service.execute(product_id: 0) }.to raise_error(
          ArgumentError, '商品が見つかりません'
        )
      end
    end

    context '無効なIDが渡された場合' do
      it 'nilのIDでエラーが発生する' do
        expect { service.execute(product_id: nil) }.to raise_error(
          ArgumentError, '商品IDが空です'
        )
      end

      it '文字列のIDは整数に変換される' do
        allow(product_repository).to receive(:find).and_return(nil)

        expect { service.execute(product_id: '1') }.to raise_error(
          ArgumentError, '商品が見つかりません'
        )
      end
    end

    context 'リポジトリでエラーが発生した場合' do
      before do
        allow(product_repository).to receive(:find).and_raise(StandardError, 'Database error')
      end

      it 'エラーが再発生する' do
        expect { service.execute(product_id: 1) }.to raise_error(StandardError, 'Database error')
      end
    end

    context '複数の商品を取得する場合' do
      let(:product1) { create(:product, name: 'Product 1') }
      let(:product2) { create(:product, name: 'Product 2') }

      let(:product_entity1) do
        Domain::ProductAggregate::Entity::ProductEntity.new(
          id: Domain::ProductAggregate::ValueObject::ProductId.new(product1.id),
          name: product1.name,
          description: product1.description,
          price: Domain::ProductAggregate::ValueObject::Price.new(product1.price),
          stock_quantity: product1.stock_quantity
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
        allow(product_repository).to receive(:find).with(
          Domain::ProductAggregate::ValueObject::ProductId.new(product1.id)
        ).and_return(product_entity1)
        allow(product_repository).to receive(:find).with(
          Domain::ProductAggregate::ValueObject::ProductId.new(product2.id)
        ).and_return(product_entity2)
      end

      it 'それぞれの商品を正しく取得できる' do
        result1 = service.execute(product_id: product1.id)
        result2 = service.execute(product_id: product2.id)

        expect(result1.name).to eq('Product 1')
        expect(result2.name).to eq('Product 2')
      end
    end
  end
end

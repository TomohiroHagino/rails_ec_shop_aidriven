# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::Product::Entity::ProductEntity do
  let(:product_id) { Domain::Product::ValueObject::ProductId.new(1) }
  let(:price) { Domain::Product::ValueObject::Price.new(1000) }
  let(:product) do
    described_class.new(
      id: product_id,
      name: 'テスト商品',
      description: '商品説明',
      price: price,
      stock_quantity: 10
    )
  end

  describe '#initialize' do
    it '商品エンティティが作成される' do
      expect(product.id).to eq(product_id)
      expect(product.name).to eq('テスト商品')
      expect(product.description).to eq('商品説明')
      expect(product.price).to eq(price)
      expect(product.stock_quantity).to eq(10)
    end

    it '名前が空の場合はエラーが発生する' do
      expect do
        described_class.new(
          id: product_id,
          name: '',
          description: '説明',
          price: price,
          stock_quantity: 10
        )
      end.to raise_error(ArgumentError, '商品名が空です')
    end

    it '在庫数が負の場合はエラーが発生する' do
      expect do
        described_class.new(
          id: product_id,
          name: '商品',
          description: '説明',
          price: price,
          stock_quantity: -1
        )
      end.to raise_error(ArgumentError, '在庫数が負の値です')
    end
  end

  describe '#change_price' do
    it '価格を変更できる' do
      new_price = Domain::Product::ValueObject::Price.new(2000)
      product.change_price(new_price)
      expect(product.price).to eq(new_price)
    end
  end

  describe '#add_stock' do
    it '在庫を追加できる' do
      product.add_stock(5)
      expect(product.stock_quantity).to eq(15)
    end

    it '0以下の数量は追加できない' do
      expect { product.add_stock(0) }.to raise_error(ArgumentError, '数量は正の数である必要があります')
      expect { product.add_stock(-5) }.to raise_error(ArgumentError, '数量は正の数である必要があります')
    end
  end

  describe '#reduce_stock' do
    it '在庫を減らせる' do
      product.reduce_stock(3)
      expect(product.stock_quantity).to eq(7)
    end

    it '在庫が不足している場合はエラーが発生する' do
      expect { product.reduce_stock(11) }.to raise_error(ArgumentError, '在庫が不足しています')
    end

    it '0以下の数量は減らせない' do
      expect { product.reduce_stock(0) }.to raise_error(ArgumentError, '数量は正の数である必要があります')
    end
  end

  describe '#in_stock?' do
    it '在庫がある場合はtrueを返す' do
      expect(product.in_stock?(5)).to be true
    end

    it '在庫が不足している場合はfalseを返す' do
      expect(product.in_stock?(11)).to be false
    end

    it '引数なしの場合は1個の在庫をチェックする' do
      expect(product.in_stock?).to be true
    end
  end
end


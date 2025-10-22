# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Product::ListProductsService do
  let(:service) { described_class.new }

  describe '#execute' do
    let!(:product1) { create(:product, name: '商品1', stock_quantity: 10) }
    let!(:product2) { create(:product, name: '商品2', stock_quantity: 5) }

    it 'すべての商品を取得できる' do
      products = service.execute
      expect(products.size).to eq(2)
      expect(products).to all(be_a(Domain::ProductAggregate::Entity::ProductEntity))
    end
  end

  describe '#execute_in_stock' do
    let!(:in_stock_product) { create(:product, name: '在庫あり', stock_quantity: 10) }
    let!(:out_of_stock_product) { create(:product, name: '在庫なし', stock_quantity: 0) }

    it '在庫のある商品のみ取得できる' do
      products = service.execute_in_stock
      expect(products.size).to eq(1)
      expect(products.first.name).to eq('在庫あり')
    end
  end
end


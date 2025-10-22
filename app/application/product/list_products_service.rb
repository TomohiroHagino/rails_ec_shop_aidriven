# frozen_string_literal: true

module Application
  module Product
    # 商品一覧取得ユースケース
    class ListProductsService
      def initialize(product_repository: Infrastructure::Product::Repository::ProductRepositoryImpl.new)
        @product_repository = product_repository
      end

      # すべての商品を取得
      # @return [Array<Domain::ProductAggregate::Entity::ProductEntity>]
      def execute
        @product_repository.all
      end

      # 在庫のある商品を取得
      # @return [Array<Domain::ProductAggregate::Entity::ProductEntity>]
      def execute_in_stock
        @product_repository.in_stock
      end
    end
  end
end


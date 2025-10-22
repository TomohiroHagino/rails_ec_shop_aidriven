# frozen_string_literal: true

module Application
  module ProductAggregate
    # 商品詳細取得ユースケース
    class GetProductService
      def initialize(product_repository: Infrastructure::Product::Repository::ProductRepositoryImpl.new)
        @product_repository = product_repository
      end

      # 商品を取得
      # @param product_id [Integer]
      # @return [Domain::ProductAggregate::Entity::ProductEntity]
      def execute(product_id:)
        product_id_vo = Domain::ProductAggregate::ValueObject::ProductId.new(product_id)
        product = @product_repository.find(product_id_vo)

        raise ArgumentError, '商品が見つかりません' unless product

        product
      end
    end
  end
end


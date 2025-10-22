# frozen_string_literal: true

module Domain
  module Product
    module Repository
      # 商品リポジトリのインターフェース
      class ProductRepository
        # IDで商品を検索
        # @param id [ValueObject::ProductId]
        # @return [Entity::ProductEntity, nil]
        def find(id)
          raise NotImplementedError
        end

        # すべての商品を取得
        # @return [Array<Entity::ProductEntity>]
        def all
          raise NotImplementedError
        end

        # 在庫のある商品を取得
        # @return [Array<Entity::ProductEntity>]
        def in_stock
          raise NotImplementedError
        end

        # 商品を保存
        # @param product [Entity::ProductEntity]
        # @return [Entity::ProductEntity]
        def save(product)
          raise NotImplementedError
        end

        # 商品を削除
        # @param id [ValueObject::ProductId]
        # @return [Boolean]
        def delete(id)
          raise NotImplementedError
        end
      end
    end
  end
end


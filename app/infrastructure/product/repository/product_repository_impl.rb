# frozen_string_literal: true

module Infrastructure
  module Product
    module Repository
      # 商品リポジトリの実装（ActiveRecord使用）
      class ProductRepositoryImpl < Domain::Product::Repository::ProductRepository
        # IDで商品を検索
        def find(id)
          product = ::Product.find_by(id: id.value)
          return nil unless product

          to_entity(product)
        end

        # すべての商品を取得
        def all
          ::Product.all.map { |product| to_entity(product) }
        end

        # 在庫のある商品を取得
        def in_stock
          ::Product.where('stock_quantity > ?', 0).map { |product| to_entity(product) }
        end

        # 商品を保存
        def save(product)
          if product.id.nil?
            create_product(product)
          else
            update_product(product)
          end
        end

        # 商品を削除
        def delete(id)
          product = ::Product.find_by(id: id.value)
          return false unless product

          product.destroy
          true
        end

        private

        # ProductからProductEntityに変換
        def to_entity(product)
          Domain::Product::Entity::ProductEntity.new(
            id: Domain::Product::ValueObject::ProductId.new(product.id),
            name: product.name,
            description: product.description,
            price: Domain::Product::ValueObject::Price.new(product.price),
            stock_quantity: product.stock_quantity,
            created_at: product.created_at,
            updated_at: product.updated_at
          )
        end

        # ProductEntityからProductに変換
        def to_model(product_entity)
          ::Product.new(
            id: product_entity.id&.value,
            name: product_entity.name,
            description: product_entity.description,
            price: product_entity.price.value,
            stock_quantity: product_entity.stock_quantity
          )
        end

        # 商品を新規作成
        def create_product(product_entity)
          product = to_model(product_entity)
          product.save!
          to_entity(product)
        end

        # 商品を更新
        def update_product(product_entity)
          product = ::Product.find(product_entity.id.value)
          product.update!(
            name: product_entity.name,
            description: product_entity.description,
            price: product_entity.price.value,
            stock_quantity: product_entity.stock_quantity
          )
          to_entity(product)
        end
      end
    end
  end
end

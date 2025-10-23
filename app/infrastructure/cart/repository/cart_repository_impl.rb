# frozen_string_literal: true

module Infrastructure
  module Cart
    module Repository
      # カートリポジトリの実装（ActiveRecord使用）
      class CartRepositoryImpl < Domain::CartAggregate::Repository::CartRepository
        # IDでカートアイテムを検索
        def find(id)
          cart_item = ::CartItem.find_by(id: id.value)
          return nil unless cart_item

          to_entity(cart_item)
        end

        # ユーザーIDでカートアイテムを取得
        def find_by_user_id(user_id)
          ::CartItem.where(user_id: user_id.value).map { |cart_item| to_entity(cart_item) }
        end

        # ユーザーIDと商品IDでカートアイテムを検索
        def find_by_user_and_product(user_id, product_id)
          cart_item = ::CartItem.find_by(user_id: user_id.value, product_id: product_id.value)
          return nil unless cart_item

          to_entity(cart_item)
        end

        # カートアイテムを保存
        def save(cart_item)
          if cart_item.id.nil?
            create_cart_item(cart_item)
          else
            update_cart_item(cart_item)
          end
        end

        # カートアイテムを削除
        def delete(id)
          cart_item = ::CartItem.find_by(id: id.value)
          return false unless cart_item

          cart_item.destroy
          cart_item.destroyed?
        end

        # ユーザーのカートをすべて削除
        def delete_by_user_id(user_id)
          ::CartItem.where(user_id: user_id.value).destroy_all
          true
        end

        private

        # CartItemからCartItemEntityに変換
        def to_entity(cart_item)
          Domain::CartAggregate::Entity::CartItemEntity.new(
            id: Domain::CartAggregate::ValueObject::CartItemId.new(cart_item.id),
            user_id: Domain::UserAggregate::ValueObject::UserId.new(cart_item.user_id),
            product_id: Domain::ProductAggregate::ValueObject::ProductId.new(cart_item.product_id),
            quantity: cart_item.quantity,
            created_at: cart_item.created_at,
            updated_at: cart_item.updated_at
          )
        end

        # CartItemEntityからCartItemに変換
        def to_model(cart_item_entity)
          ::CartItem.new(
            id: cart_item_entity.id&.value,
            user_id: cart_item_entity.user_id.value,
            product_id: cart_item_entity.product_id.value,
            quantity: cart_item_entity.quantity
          )
        end

        # カートアイテムを新規作成
        def create_cart_item(cart_item_entity)
          cart_item = to_model(cart_item_entity)
          cart_item.save!
          to_entity(cart_item)
        end

        # カートアイテムを更新
        def update_cart_item(cart_item_entity)
          cart_item = ::CartItem.find(cart_item_entity.id.value)
          cart_item.update!(
            user_id: cart_item_entity.user_id.value,
            product_id: cart_item_entity.product_id.value,
            quantity: cart_item_entity.quantity
          )
          to_entity(cart_item)
        end
      end
    end
  end
end


# frozen_string_literal: true

module Domain
  module Cart
    module Repository
      # カートリポジトリのインターフェース
      class CartRepository
        # IDでカートアイテムを検索
        # @param id [ValueObject::CartItemId]
        # @return [Entity::CartItemEntity, nil]
        def find(id)
          raise NotImplementedError
        end

        # ユーザーIDでカートアイテムを取得
        # @param user_id [Domain::User::ValueObject::UserId]
        # @return [Array<Entity::CartItemEntity>]
        def find_by_user_id(user_id)
          raise NotImplementedError
        end

        # ユーザーIDと商品IDでカートアイテムを検索
        # @param user_id [Domain::User::ValueObject::UserId]
        # @param product_id [Domain::Product::ValueObject::ProductId]
        # @return [Entity::CartItemEntity, nil]
        def find_by_user_and_product(user_id, product_id)
          raise NotImplementedError
        end

        # カートアイテムを保存
        # @param cart_item [Entity::CartItemEntity]
        # @return [Entity::CartItemEntity]
        def save(cart_item)
          raise NotImplementedError
        end

        # カートアイテムを削除
        # @param id [ValueObject::CartItemId]
        # @return [Boolean]
        def delete(id)
          raise NotImplementedError
        end

        # ユーザーのカートをすべて削除
        # @param user_id [Domain::User::ValueObject::UserId]
        # @return [Boolean]
        def delete_by_user_id(user_id)
          raise NotImplementedError
        end
      end
    end
  end
end


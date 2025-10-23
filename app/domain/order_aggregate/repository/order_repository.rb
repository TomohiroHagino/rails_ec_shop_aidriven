# frozen_string_literal: true

module Domain
  module OrderAggregate
    module Repository
      # 注文リポジトリのインターフェース
      class OrderRepository
        # IDで注文を検索
        # @param id [ValueObject::OrderId]
        # @return [Entity::OrderEntity, nil]
        def find(id)
          raise NotImplementedError
        end

        # ユーザーIDで注文を取得
        # @param user_id [Domain::UserAggregate::ValueObject::UserId]
        # @return [Array<Entity::OrderEntity>]
        def find_by_user_id(user_id)
          raise NotImplementedError
        end

        # すべての注文を取得
        # @return [Array<Entity::OrderEntity>]
        def all
          raise NotImplementedError
        end

        # 注文を保存
        # @param order [Entity::OrderEntity]
        # @return [Entity::OrderEntity]
        def save(order)
          raise NotImplementedError
        end

        # 注文を削除
        # @param id [ValueObject::OrderId]
        # @return [Boolean]
        def delete(id)
          raise NotImplementedError
        end

        # 注文アイテムを取得
        # @param order_id [ValueObject::OrderId]
        # @return [Array<Entity::OrderItemEntity>]
        def find_items_by_order_id(order_id)
          raise NotImplementedError
        end

        # 注文アイテムを保存
        # @param order_item [Entity::OrderItemEntity]
        # @return [Entity::OrderItemEntity]
        def save_item(order_item)
          raise NotImplementedError
        end

        # 期限切れのpending注文を取得
        # @param cutoff_date [Time] この日時より古い注文を対象
        # @return [Array<Entity::OrderEntity>]
        def find_stale_pending_orders(cutoff_date)
          raise NotImplementedError
        end
      end
    end
  end
end


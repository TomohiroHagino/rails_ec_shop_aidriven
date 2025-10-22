# frozen_string_literal: true

module Infrastructure
  module Order
    module Repository
      # 注文リポジトリの実装（ActiveRecord使用）
      class OrderRepositoryImpl < Domain::OrderAggregate::Repository::OrderRepository
        # IDで注文を検索
        def find(id)
          order = ::Order.find_by(id: id.value)
          return nil unless order

          to_entity(order)
        end

        # ユーザーIDで注文を取得
        def find_by_user_id(user_id)
          ::Order.where(user_id: user_id.value).order(created_at: :desc).map { |order| to_entity(order) }
        end

        # すべての注文を取得
        def all
          ::Order.order(created_at: :desc).map { |order| to_entity(order) }
        end

        # 注文を保存
        def save(order)
          if order.id.nil?
            create_order(order)
          else
            update_order(order)
          end
        end

        # 注文を削除
        def delete(id)
          order = ::Order.find_by(id: id.value)
          return false unless order

          order.destroy
          true
        end

        # 注文アイテムを取得
        def find_items_by_order_id(order_id)
          ::OrderItem.where(order_id: order_id.value).map { |item| to_item_entity(item) }
        end

        # 注文アイテムを保存
        def save_item(order_item)
          if order_item.id.nil?
            create_order_item(order_item)
          else
            update_order_item(order_item)
          end
        end

        private

        # OrderからOrderEntityに変換
        def to_entity(order)
          Domain::OrderAggregate::Entity::OrderEntity.new(
            id: Domain::OrderAggregate::ValueObject::OrderId.new(order.id),
            user_id: Domain::UserAggregate::ValueObject::UserId.new(order.user_id),
            total_amount: Domain::ProductAggregate::ValueObject::Price.new(order.total_amount),
            status: Domain::OrderAggregate::ValueObject::OrderStatus.new(order.status),
            created_at: order.created_at,
            updated_at: order.updated_at
          )
        end

        # OrderEntityからOrderに変換
        def to_model(order_entity)
          ::Order.new(
            id: order_entity.id&.value,
            user_id: order_entity.user_id.value,
            total_amount: order_entity.total_amount.value,
            status: order_entity.status.value
          )
        end

        # OrderItemからOrderItemEntityに変換
        def to_item_entity(item)
          Domain::OrderAggregate::Entity::OrderItemEntity.new(
            id: item.id,
            order_id: Domain::OrderAggregate::ValueObject::OrderId.new(item.order_id),
            product_id: Domain::ProductAggregate::ValueObject::ProductId.new(item.product_id),
            quantity: item.quantity,
            price: Domain::ProductAggregate::ValueObject::Price.new(item.price),
            created_at: item.created_at,
            updated_at: item.updated_at
          )
        end

        # OrderItemEntityからOrderItemに変換
        def to_item_model(order_item_entity)
          ::OrderItem.new(
            id: order_item_entity.id,
            order_id: order_item_entity.order_id.value,
            product_id: order_item_entity.product_id.value,
            quantity: order_item_entity.quantity,
            price: order_item_entity.price.value
          )
        end

        # 注文を新規作成
        def create_order(order_entity)
          order = to_model(order_entity)
          order.save!
          to_entity(order)
        end

        # 注文を更新
        def update_order(order_entity)
          order = ::Order.find(order_entity.id.value)
          order.update!(
            user_id: order_entity.user_id.value,
            total_amount: order_entity.total_amount.value,
            status: order_entity.status.value
          )
          to_entity(order)
        end

        # 注文アイテムを新規作成
        def create_order_item(order_item_entity)
          item = to_item_model(order_item_entity)
          item.save!
          to_item_entity(item)
        end

        # 注文アイテムを更新
        def update_order_item(order_item_entity)
          item = ::OrderItem.find(order_item_entity.id)
          item.update!(
            order_id: order_item_entity.order_id.value,
            product_id: order_item_entity.product_id.value,
            quantity: order_item_entity.quantity,
            price: order_item_entity.price.value
          )
          to_item_entity(item)
        end
      end
    end
  end
end

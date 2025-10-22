# frozen_string_literal: true

module Domain
  module OrderAggregate
    module Entity
      # 注文アイテムエンティティ
      class OrderItemEntity
        attr_reader :id, :order_id, :product_id, :quantity, :price, :created_at, :updated_at

        def initialize(id:, order_id:, product_id:, quantity:, price:, created_at: nil, updated_at: nil)
          @id = id
          @order_id = order_id
          @product_id = product_id
          @quantity = quantity
          @price = price
          @created_at = created_at
          @updated_at = updated_at

          validate!
        end

        # 小計を計算
        def subtotal
          Domain::ProductAggregate::ValueObject::Price.new(price.value * quantity)
        end

        def ==(other)
          return false unless other.is_a?(OrderItemEntity)

          id == other.id
        end

        alias eql? ==

        def hash
          id.hash
        end

        private

        def validate!
          raise ArgumentError, '注文IDが空です' if order_id.nil?
          raise ArgumentError, '商品IDが空です' if product_id.nil?
          raise ArgumentError, '数量は正の数である必要があります' if quantity <= 0
          raise ArgumentError, '価格が空です' unless price.is_a?(Domain::ProductAggregate::ValueObject::Price)
        end
      end
    end
  end
end


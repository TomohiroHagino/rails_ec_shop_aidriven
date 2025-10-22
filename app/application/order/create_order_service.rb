# frozen_string_literal: true

module Application
  module Order
    # 注文作成ユースケース
    class CreateOrderService
      def initialize(
        order_repository: Infrastructure::Order::Repository::OrderRepositoryImpl.new,
        cart_repository: Infrastructure::Cart::Repository::CartRepositoryImpl.new,
        product_repository: Infrastructure::Product::Repository::ProductRepositoryImpl.new
      )
        @order_repository = order_repository
        @cart_repository = cart_repository
        @product_repository = product_repository
      end

      # カートから注文を作成
      # @param user_id [Integer]
      # @return [Domain::OrderAggregate::Entity::OrderEntity]
      def execute(user_id:)
        user_id_vo = Domain::UserAggregate::ValueObject::UserId.new(user_id)

        # カートアイテムを取得
        cart_items = @cart_repository.find_by_user_id(user_id_vo)
        raise ArgumentError, 'カートが空です' if cart_items.empty?

        # 合計金額を計算し、在庫をチェック
        total_amount = BigDecimal('0')
        order_items_data = []

        cart_items.each do |cart_item|
          product = @product_repository.find(cart_item.product_id)
          raise ArgumentError, '商品が見つかりません' unless product
          raise ArgumentError, "#{product.name}の在庫が不足しています" unless product.in_stock?(cart_item.quantity)

          subtotal = product.price.value * cart_item.quantity
          total_amount += subtotal

          order_items_data << {
            product_id: cart_item.product_id,
            product: product,
            quantity: cart_item.quantity,
            price: product.price
          }
        end

        # トランザクション内で注文を作成
        ActiveRecord::Base.transaction do
          # 注文を作成
          order = Domain::OrderAggregate::Entity::OrderEntity.new(
            id: nil,
            user_id: user_id_vo,
            total_amount: Domain::ProductAggregate::ValueObject::Price.new(total_amount),
            status: Domain::OrderAggregate::ValueObject::OrderStatus.new(Domain::OrderAggregate::ValueObject::OrderStatus::PENDING)
          )
          saved_order = @order_repository.save(order)

          # 注文アイテムを作成
          order_items_data.each do |item_data|
            order_item = Domain::OrderAggregate::Entity::OrderItemEntity.new(
              id: nil,
              order_id: saved_order.id,
              product_id: item_data[:product_id],
              quantity: item_data[:quantity],
              price: item_data[:price]
            )
            @order_repository.save_item(order_item)

            # 在庫を減らす
            item_data[:product].reduce_stock(item_data[:quantity])
            @product_repository.save(item_data[:product])
          end

          # カートをクリア
          @cart_repository.delete_by_user_id(user_id_vo)

          saved_order
        end
      end
    end
  end
end


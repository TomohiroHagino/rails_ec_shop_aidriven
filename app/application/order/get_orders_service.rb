# frozen_string_literal: true

module Application
  module Order
    # 注文一覧取得ユースケース
    class GetOrdersService
      def initialize(
        order_repository: Infrastructure::Order::Repository::OrderRepositoryImpl.new,
        product_repository: Infrastructure::Product::Repository::ProductRepositoryImpl.new
      )
        @order_repository = order_repository
        @product_repository = product_repository
      end

      # ユーザーの注文一覧を取得
      # @param user_id [Integer]
      # @return [Array<Hash>] 注文とそのアイテムのリスト
      def execute(user_id:)
        user_id_vo = Domain::UserAggregate::ValueObject::UserId.new(user_id)
        orders = @order_repository.find_by_user_id(user_id_vo)

        orders.map do |order|
          order_items = @order_repository.find_items_by_order_id(order.id)
          
          # 商品情報を取得
          items_with_products = order_items.map do |item|
            product = @product_repository.find(item.product_id)
            {
              order_item: item,
              product: product
            }
          end

          {
            order: order,
            items: items_with_products
          }
        end
      end
    end
  end
end

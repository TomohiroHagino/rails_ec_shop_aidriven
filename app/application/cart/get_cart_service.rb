# frozen_string_literal: true

module Application
  module Cart
    # カート取得ユースケース
    class GetCartService
      def initialize(
        cart_repository: Infrastructure::Cart::Repository::CartRepositoryImpl.new,
        product_repository: Infrastructure::Product::Repository::ProductRepositoryImpl.new
      )
        @cart_repository = cart_repository
        @product_repository = product_repository
      end

      # ユーザーのカートを取得
      # @param user_id [Integer]
      # @return [Hash] { cart_items: Array, products: Hash, total: BigDecimal }
      def execute(user_id:)
        user_id_vo = Domain::User::ValueObject::UserId.new(user_id)
        cart_items = @cart_repository.find_by_user_id(user_id_vo)

        # 商品情報を取得
        products = {}
        total = BigDecimal('0')

        cart_items.each do |cart_item|
          product = @product_repository.find(cart_item.product_id)
          products[cart_item.product_id.value] = product

          if product
            total += product.price.value * cart_item.quantity
          end
        end

        {
          cart_items: cart_items,
          products: products,
          total: total
        }
      end
    end
  end
end


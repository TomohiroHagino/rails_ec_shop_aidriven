# frozen_string_literal: true

module Application
  module Cart
    # カート追加ユースケース
    class AddToCartService
      def initialize(
        cart_repository: Infrastructure::Cart::Repository::CartRepositoryImpl.new,
        product_repository: Infrastructure::Product::Repository::ProductRepositoryImpl.new
      )
        @cart_repository = cart_repository
        @product_repository = product_repository
      end

      # カートに商品を追加
      # @param user_id [Integer]
      # @param product_id [Integer]
      # @param quantity [Integer]
      # @return [Domain::Cart::Entity::CartItemEntity]
      def execute(user_id:, product_id:, quantity: 1)
        user_id_vo = Domain::User::ValueObject::UserId.new(user_id)
        product_id_vo = Domain::Product::ValueObject::ProductId.new(product_id)

        # 商品の在庫チェック
        product = @product_repository.find(product_id_vo)
        raise ArgumentError, '商品が見つかりません' unless product
        raise ArgumentError, '在庫が不足しています' unless product.in_stock?(quantity)

        # 既存のカートアイテムをチェック
        existing_cart_item = @cart_repository.find_by_user_and_product(user_id_vo, product_id_vo)

        if existing_cart_item
          # 既存のアイテムの数量を増やす
          existing_cart_item.increase_quantity(quantity)
          @cart_repository.save(existing_cart_item)
        else
          # 新しいカートアイテムを作成
          cart_item = Domain::Cart::Entity::CartItemEntity.new(
            id: nil,
            user_id: user_id_vo,
            product_id: product_id_vo,
            quantity: quantity
          )
          @cart_repository.save(cart_item)
        end
      end
    end
  end
end


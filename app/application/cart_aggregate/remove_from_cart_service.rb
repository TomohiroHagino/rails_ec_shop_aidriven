# frozen_string_literal: true

module Application
  module CartAggregate
    # カートから削除ユースケース
    class RemoveFromCartService
      def initialize(cart_repository: Infrastructure::Cart::Repository::CartRepositoryImpl.new)
        @cart_repository = cart_repository
      end

      # カートアイテムを削除
      # @param cart_item_id [Integer]
      # @return [Boolean]
      def execute(cart_item_id:)
        cart_item_id_vo = Domain::CartAggregate::ValueObject::CartItemId.new(cart_item_id)
        @cart_repository.delete(cart_item_id_vo)
      end
    end
  end
end


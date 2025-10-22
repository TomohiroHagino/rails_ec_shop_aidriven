# frozen_string_literal: true

module Domain
  module CartAggregate
    module Entity
      # カートアイテムエンティティ
      class CartItemEntity
        attr_reader :id, :user_id, :product_id, :quantity, :created_at, :updated_at

        def initialize(id:, user_id:, product_id:, quantity:, created_at: nil, updated_at: nil)
          @id = id
          @user_id = user_id
          @product_id = product_id
          @quantity = quantity
          @created_at = created_at
          @updated_at = updated_at

          validate!
        end

        # 数量を変更
        def change_quantity(new_quantity)
          raise ArgumentError, '数量は正の数である必要があります' if new_quantity <= 0

          @quantity = new_quantity
          @updated_at = Time.current
        end

        # 数量を増やす
        def increase_quantity(amount = 1)
          raise ArgumentError, '数量は正の数である必要があります' if amount <= 0

          @quantity += amount
          @updated_at = Time.current
        end

        # 数量を減らす
        def decrease_quantity(amount = 1)
          raise ArgumentError, '数量は正の数である必要があります' if amount <= 0
          raise ArgumentError, '数量が負になります' if @quantity - amount < 0

          @quantity -= amount
          @updated_at = Time.current
        end

        def ==(other)
          return false unless other.is_a?(CartItemEntity)

          id == other.id
        end

        alias eql? ==

        def hash
          id.hash
        end

        private

        def validate!
          raise ArgumentError, 'ユーザーIDが空です' if user_id.nil?
          raise ArgumentError, '商品IDが空です' if product_id.nil?
          raise ArgumentError, '数量は正の数である必要があります' if quantity <= 0
        end
      end
    end
  end
end


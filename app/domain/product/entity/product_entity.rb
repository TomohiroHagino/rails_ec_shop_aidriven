# frozen_string_literal: true

module Domain
  module Product
    module Entity
      # 商品エンティティ（Aggregate Root）
      class ProductEntity
        attr_reader :id, :name, :description, :price, :stock_quantity, :created_at, :updated_at

        def initialize(id:, name:, description:, price:, stock_quantity:, created_at: nil, updated_at: nil)
          @id = id
          @name = name
          @description = description
          @price = price
          @stock_quantity = stock_quantity
          @created_at = created_at
          @updated_at = updated_at

          validate!
        end

        # 名前を変更
        def change_name(new_name)
          raise ArgumentError, '商品名が空です' if new_name.nil? || new_name.empty?

          @name = new_name
          @updated_at = Time.current
        end

        # 説明を変更
        def change_description(new_description)
          @description = new_description
          @updated_at = Time.current
        end

        # 価格を変更
        def change_price(new_price)
          raise ArgumentError, '価格が空です' unless new_price.is_a?(ValueObject::Price)

          @price = new_price
          @updated_at = Time.current
        end

        # 在庫を追加
        def add_stock(quantity)
          raise ArgumentError, '数量は正の数である必要があります' if quantity <= 0

          @stock_quantity += quantity
          @updated_at = Time.current
        end

        # 在庫を減らす
        def reduce_stock(quantity)
          raise ArgumentError, '数量は正の数である必要があります' if quantity <= 0
          raise ArgumentError, '在庫が不足しています' if @stock_quantity < quantity

          @stock_quantity -= quantity
          @updated_at = Time.current
        end

        # 在庫があるかチェック
        def in_stock?(quantity = 1)
          @stock_quantity >= quantity
        end

        def ==(other)
          return false unless other.is_a?(ProductEntity)

          id == other.id
        end

        alias eql? ==

        def hash
          id.hash
        end

        private

        def validate!
          raise ArgumentError, '商品名が空です' if name.nil? || name.empty?
          raise ArgumentError, '価格が空です' unless price.is_a?(ValueObject::Price)
          raise ArgumentError, '在庫数が負の値です' if stock_quantity < 0
        end
      end
    end
  end
end


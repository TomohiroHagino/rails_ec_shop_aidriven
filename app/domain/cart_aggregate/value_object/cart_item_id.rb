# frozen_string_literal: true

module Domain
  module CartAggregate
    module ValueObject
      # カートアイテムIDを表す値オブジェクト
      class CartItemId
        attr_reader :value

        def initialize(value)
          raise ArgumentError, 'カートアイテムIDが空です' if value.nil?

          @value = value.to_i
        end

        def ==(other)
          return false unless other.is_a?(CartItemId)

          value == other.value
        end

        alias eql? ==

        def hash
          value.hash
        end

        def to_i
          value
        end

        def to_s
          value.to_s
        end
      end
    end
  end
end


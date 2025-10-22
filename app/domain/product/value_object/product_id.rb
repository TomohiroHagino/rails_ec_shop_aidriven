# frozen_string_literal: true

module Domain
  module Product
    module ValueObject
      # 商品IDを表す値オブジェクト
      class ProductId
        attr_reader :value

        def initialize(value)
          raise ArgumentError, '商品IDが空です' if value.nil?

          @value = value.to_i
        end

        def ==(other)
          return false unless other.is_a?(ProductId)

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


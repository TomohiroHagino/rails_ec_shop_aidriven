# frozen_string_literal: true

module Domain
  module OrderAggregate
    module ValueObject
      # 注文IDを表す値オブジェクト
      class OrderId
        attr_reader :value

        def initialize(value)
          raise ArgumentError, '注文IDが空です' if value.nil?

          @value = value.to_i
        end

        def ==(other)
          return false unless other.is_a?(OrderId)

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


# frozen_string_literal: true

module Domain
  module Product
    module ValueObject
      # 価格を表す値オブジェクト
      class Price
        attr_reader :value

        def initialize(value)
          raise ArgumentError, '価格が空です' if value.nil?
          raise ArgumentError, '価格は0以上である必要があります' if value.to_f < 0

          @value = BigDecimal(value.to_s)
        end

        def ==(other)
          return false unless other.is_a?(Price)

          value == other.value
        end

        alias eql? ==

        def hash
          value.hash
        end

        def to_f
          value.to_f
        end

        def to_s
          value.to_s('F')
        end

        def to_i
          value.to_i
        end
      end
    end
  end
end


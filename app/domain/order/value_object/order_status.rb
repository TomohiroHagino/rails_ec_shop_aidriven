# frozen_string_literal: true

module Domain
  module Order
    module ValueObject
      # 注文ステータスを表す値オブジェクト
      class OrderStatus
        PENDING = 'pending'
        CONFIRMED = 'confirmed'
        SHIPPED = 'shipped'
        DELIVERED = 'delivered'
        CANCELLED = 'cancelled'

        VALID_STATUSES = [PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED].freeze

        attr_reader :value

        def initialize(value)
          raise ArgumentError, 'ステータスが空です' if value.nil? || value.empty?
          raise ArgumentError, "無効なステータスです: #{value}" unless VALID_STATUSES.include?(value)

          @value = value
        end

        def pending?
          value == PENDING
        end

        def confirmed?
          value == CONFIRMED
        end

        def shipped?
          value == SHIPPED
        end

        def delivered?
          value == DELIVERED
        end

        def cancelled?
          value == CANCELLED
        end

        def ==(other)
          return false unless other.is_a?(OrderStatus)

          value == other.value
        end

        alias eql? ==

        def hash
          value.hash
        end

        def to_s
          value
        end
      end
    end
  end
end


# frozen_string_literal: true

module Domain
  module OrderAggregate
    module Entity
      # 注文エンティティ（Aggregate Root）
      class OrderEntity
        attr_reader :id, :user_id, :total_amount, :status, :created_at, :updated_at

        def initialize(id:, user_id:, total_amount:, status:, created_at: nil, updated_at: nil)
          @id = id
          @user_id = user_id
          @total_amount = total_amount
          @status = status
          @created_at = created_at
          @updated_at = updated_at

          validate!
        end

        # 注文を確定
        def confirm
          raise ArgumentError, '確定できません' unless status.pending?

          @status = ValueObject::OrderStatus.new(ValueObject::OrderStatus::CONFIRMED)
          @updated_at = Time.current
        end

        # 注文を出荷
        def ship
          raise ArgumentError, '出荷できません' unless status.confirmed?

          @status = ValueObject::OrderStatus.new(ValueObject::OrderStatus::SHIPPED)
          @updated_at = Time.current
        end

        # 注文を配達完了
        def deliver
          raise ArgumentError, '配達完了できません' unless status.shipped?

          @status = ValueObject::OrderStatus.new(ValueObject::OrderStatus::DELIVERED)
          @updated_at = Time.current
        end

        # 注文をキャンセル
        def cancel
          raise ArgumentError, 'キャンセルできません' if status.delivered? || status.cancelled?

          @status = ValueObject::OrderStatus.new(ValueObject::OrderStatus::CANCELLED)
          @updated_at = Time.current
        end

        def ==(other)
          return false unless other.is_a?(OrderEntity)

          id == other.id
        end

        alias eql? ==

        def hash
          id.hash
        end

        private

        def validate!
          raise ArgumentError, 'ユーザーIDが空です' if user_id.nil?
          raise ArgumentError, '合計金額が空です' if total_amount.nil?
          raise ArgumentError, 'ステータスが空です' unless status.is_a?(ValueObject::OrderStatus)
        end
      end
    end
  end
end


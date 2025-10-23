# frozen_string_literal: true

module Application
  module OrderAggregate
    # 期限切れ注文キャンセルユースケース
    class CancelStaleOrdersService
      def initialize(
        order_repository: Infrastructure::Order::Repository::OrderRepositoryImpl.new
      )
        @order_repository = order_repository
      end

      # 1週間以上経過したpending注文をキャンセル
      # @param days_ago [Integer] 何日前の注文を対象にするか（デフォルト: 7）
      # @param dry_run [Boolean] dry_runモード（実際にはキャンセルしない）
      # @return [Hash] { cancelled_count: Integer, errors: Array, dry_run: Boolean }
      def execute(days_ago: 7, dry_run: false)
        cutoff_date = days_ago.days.ago.beginning_of_day
        cancelled_count = 0
        errors = []

        # 期限切れのpending注文を取得
        stale_orders = @order_repository.find_stale_pending_orders(cutoff_date)

        stale_orders.each do |order|
          begin
            if dry_run
              # dry_runモードではログのみ出力
              cancelled_count += 1
              Rails.logger.info "[DRY RUN] 注文ID #{order.id.value} をキャンセル対象としました（実際にはキャンセルしません）"
            else
              # 注文ステータスをcancelledに変更
              cancelled_order = Domain::OrderAggregate::Entity::OrderEntity.new(
                id: order.id,
                user_id: order.user_id,
                status: Domain::OrderAggregate::ValueObject::OrderStatus.new('cancelled'),
                total_amount: order.total_amount,
                created_at: order.created_at,
                updated_at: Time.current
              )

              @order_repository.save(cancelled_order)
              cancelled_count += 1

              Rails.logger.info "注文ID #{order.id.value} をキャンセルしました"
            end
          rescue => e
            error_message = "注文ID #{order.id.value} のキャンセルに失敗: #{e.message}"
            errors << error_message
            Rails.logger.error error_message
          end
        end

        {
          cancelled_count: cancelled_count,
          errors: errors,
          total_processed: stale_orders.size,
          dry_run: dry_run
        }
      end
    end
  end
end

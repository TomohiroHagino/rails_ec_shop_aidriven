# frozen_string_literal: true

module Batch
  # 期限切れ注文キャンセルバッチ
  class CancelStaleOrdersBatch
    def self.execute(days_ago: 7, dry_run: false)
      if dry_run
        puts "【DRY RUNモード】期限切れ注文のキャンセル処理を開始します（実際にはキャンセルしません）"
      else
        puts "期限切れ注文のキャンセル処理を開始します..."
      end
      
      service = Application::OrderAggregate::CancelStaleOrdersService.new
      result = service.execute(days_ago: days_ago, dry_run: dry_run)
      
      puts "\n処理完了:"
      puts "  モード: #{result[:dry_run] ? 'DRY RUN' : '本番実行'}"
      puts "  対象注文数: #{result[:total_processed]}"
      puts "  #{result[:dry_run] ? 'キャンセル対象数' : 'キャンセル数'}: #{result[:cancelled_count]}"
      puts "  エラー数: #{result[:errors].size}"
      
      if result[:errors].any?
        puts "\nエラー詳細:"
        result[:errors].each { |error| puts "  - #{error}" }
      end
      
      if result[:dry_run]
        puts "\n※ DRY RUNモードのため、実際のキャンセルは実行されていません。"
      else
        puts "\n期限切れ注文のキャンセル処理が完了しました。"
      end
    end
  end
end

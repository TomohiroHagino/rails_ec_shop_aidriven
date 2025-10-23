# frozen_string_literal: true

module Batch
  # 期限切れ注文キャンセルバッチ
  class CancelStaleOrdersBatch
    def self.execute(days_ago: 7)
      puts "期限切れ注文のキャンセル処理を開始します..."
      
      service = Application::OrderAggregate::CancelStaleOrdersService.new
      result = service.execute(days_ago: days_ago)
      
      puts "処理完了:"
      puts "  対象注文数: #{result[:total_processed]}"
      puts "  キャンセル数: #{result[:cancelled_count]}"
      puts "  エラー数: #{result[:errors].size}"
      
      if result[:errors].any?
        puts "\nエラー詳細:"
        result[:errors].each { |error| puts "  - #{error}" }
      end
      
      puts "\n期限切れ注文のキャンセル処理が完了しました。"
    end
  end
end

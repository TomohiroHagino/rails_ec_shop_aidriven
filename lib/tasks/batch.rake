# frozen_string_literal: true

namespace :batch do
  desc '1週間以上経過したpending注文をキャンセルする'
  task cancel_stale_orders: :environment do
    # デフォルトは7日前、環境変数で変更可能
    days_ago = ENV['DAYS_AGO']&.to_i || 7
    
    Batch::CancelStaleOrdersBatch.execute(days_ago: days_ago)
  end
end

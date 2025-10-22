Rails.application.configure do
  # 本番環境固有の設定（config/application.rbの設定より優先される）

  # リクエスト間でコードをリロードしない
  config.enable_reloading = false

  # 起動時にコードを事前にロード（マルチスレッドサーバーのパフォーマンス向上）
  config.eager_load = true

  # 完全なエラーレポートを無効化し、キャッシングを有効化
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # マスターキーが ENV["RAILS_MASTER_KEY"] または config/master.key にあることを確認
  # config.require_master_key = true

  # /publicフォルダからの静的ファイル配信を無効化（ApacheやNGINXが処理）
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # アップロードファイルをローカルファイルシステムに保存
  config.active_storage.service = :local

  # すべてのアクセスをSSL経由に強制
  # config.force_ssl = true

  # 診断情報を確保するため、最低ログレベルを使用
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # すべてのログ行の先頭に以下のタグを追加
  config.log_tags = [:request_id]

  # 本番環境では別のキャッシュストアを使用
  # config.cache_store = :mem_cache_store

  # Active Jobで実際のキューイングバックエンドを使用
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "ec_shop_aidriven_production"

  config.action_mailer.perform_caching = false

  # I18nのロケールフォールバックを有効化
  config.i18n.fallbacks = true

  # 非推奨の通知を登録済みリスナーに送信
  config.active_support.deprecation = :notify

  # 標準のログフォーマッターを使用（PIDとタイムスタンプを抑制しない）
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # マイグレーション後にスキーマをダンプしない
  config.active_record.dump_schema_after_migration = false
end

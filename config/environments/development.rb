Rails.application.configure do
  # 開発環境固有の設定（config/application.rbの設定より優先される）

  # リクエストごとにアプリケーションのコードをリロード
  # レスポンス時間は遅くなるが、コード変更時にWebサーバーを再起動する必要がない
  config.enable_reloading = true

  # 起動時にコードを事前読み込みしない
  config.eager_load = false

  # 完全なエラーレポートを表示
  config.consider_all_requests_local = true

  # サーバーのタイミング情報を有効化
  config.server_timing = true

  # キャッシングの有効/無効化（デフォルトは無効）
  # rails dev:cache でキャッシングを切り替え
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # アップロードファイルをローカルファイルシステムに保存
  config.active_storage.service = :local

  # メーラーが送信できなくてもエラーを発生させない
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # 非推奨の通知をRailsロガーに出力
  config.active_support.deprecation = :log

  # 未実行のマイグレーションがある場合、ページロード時にエラーを発生
  config.active_record.migration_error = :page_load

  # データベースクエリを引き起こしたコードをログにハイライト表示
  config.active_record.verbose_query_logs = true

  # 翻訳が見つからない場合にエラーを発生
  # config.i18n.raise_on_missing_translations = true

  # レンダリングされたビューにファイル名を注釈
  # config.action_view.annotate_rendered_view_with_filenames = true
end

# テスト環境は、アプリケーションのテストスイートを実行するためだけに使用されます。
# テストデータベースは「スクラッチスペース」であり、テスト実行間でワイプおよび再作成されます。

Rails.application.configure do
  # テスト環境固有の設定（config/application.rbの設定より優先される）

  # リクエスト間でコードをリロードする（Spring使用時は無効化）
  config.enable_reloading = false

  # テンプレートをキャッシュしてパフォーマンスを向上
  config.action_view.cache_template_loading = true

  # 起動時にコードを事前読み込みしない（単一テスト実行の高速化）
  config.eager_load = ENV["CI"].present?

  # パブリックファイルサーバーをCache-Control付きで設定
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # 完全なエラーレポートを表示し、キャッシングを無効化
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # 例外テンプレートをレンダリングする代わりに例外を発生させる
  config.action_dispatch.show_exceptions = :rescuable

  # テスト環境ではリクエスト偽造保護を無効化
  config.action_controller.allow_forgery_protection = false

  # アップロードファイルを一時ディレクトリに保存
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # メールを実際には送信しない（ActionMailer::Base.deliveries配列に蓄積）
  config.action_mailer.delivery_method = :test

  # 非推奨の通知をstderrに出力
  config.active_support.deprecation = :stderr

  # 翻訳が見つからない場合にエラーを発生
  # config.i18n.raise_on_missing_translations = true

  # 例外をアプリが処理する例外ハンドラーに渡す
  config.action_dispatch.show_exceptions = :rescuable
end

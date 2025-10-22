# frozen_string_literal: true

# このファイルをまだ変更していない場合、以下の各設定オプションはデフォルト値に設定されています。
# コメントアウトされているものとそうでないものがありますが、
# コメントが外されている行は、アップグレード時に互換性を保つための保護のためです
# （つまり、将来のDeviseのバージョンでデフォルト値が変更されても壊れないようにするため）。
#
# このフックを使って、Deviseのメーラーやwardenのフックなどを設定します。
# 多くの設定オプションは、モデル内でも直接設定可能です。
Devise.setup do |config|
  # Deviseで使用されるシークレットキーです。
  # Deviseはこのキーを使用してランダムトークンを生成します。
  # このキーを変更すると、既存の確認・パスワードリセット・アンロックトークンはすべて無効になります。
  # デフォルトでは、`secret_key_base`が`secret_key`として使用されます。
  # 独自のキーを使用したい場合は、以下で変更できます。
  # config.secret_key = '064860ab9c8b64e5b89c01d1107a8b7c4749300a61a09f4c1199b5adab0f46c41d4e94c932b37b050b09baff58e7d1e4ed8865fdf7986f2c3abd4cf3bf515c7d'

  # ==> コントローラー設定
  # deviseコントローラーの親クラスを設定します。
  # config.parent_controller = 'DeviseController'

  # ==> メーラー設定
  # Devise::Mailerで表示される送信元メールアドレスを設定します。
  # 独自のメーラークラスを使用して"default from"パラメータを設定している場合は、上書きされます。
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # メール送信を担当するクラスを設定します。
  # config.mailer = 'Devise::Mailer'

  # メール送信クラスの親クラスを設定します。
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM設定
  # ORMをロードして設定します。デフォルトは:active_recordです。
  # 他にも :mongoid などが利用可能です。
  require 'devise/orm/active_record'

  # ==> 認証メカニズム設定
  # ユーザー認証に使用するキーを設定します。デフォルトは :email。
  # たとえば [:username, :subdomain] と設定すれば、両方のパラメータが認証に必要になります。
  # config.authentication_keys = [:email]

  # リクエストオブジェクトから認証に使用するパラメータを設定します。
  # 例: :request_keys = [:subdomain] とすると、サブドメインを認証に利用します。
  # config.request_keys = []

  # 大文字・小文字を区別せずに扱う認証キーを設定します。デフォルトは :email。
  config.case_insensitive_keys = [:email]

  # 前後の空白を削除する認証キーを設定します。デフォルトは :email。
  config.strip_whitespace_keys = [:email]

  # リクエストパラメータによる認証を有効にするかどうか。デフォルトはtrue。
  # 特定の戦略のみ有効にする場合は配列で指定できます。
  # config.params_authenticatable = true

  # HTTP認証を有効にするかどうか。デフォルトはfalse。
  # API専用アプリでは、:databaseを指定して有効化することが一般的です。
  # config.http_authenticatable = false

  # AJAXリクエストで401ステータスを返すかどうか。デフォルトはtrue。
  # config.http_authenticatable_on_xhr = true

  # HTTP Basic認証で使用するレルム名を設定します。デフォルトは 'Application'。
  # config.http_authentication_realm = 'Application'

  # 入力したメールアドレスが正しいか間違っているかに関わらず、
  # 確認・パスワードリカバリなどの動作を同一にするか。デフォルトはfalse。
  # config.paranoid = true

  # デフォルトではDeviseはユーザー情報をセッションに保存します。
  # 特定の戦略でセッション保存をスキップする場合に設定します。
  config.skip_session_storage = [:http_auth]

  # CSRFトークン固定攻撃を防ぐため、認証時にトークンをリセットします。
  # AJAXでサインイン・サインアップする場合は、新しいトークンを取得する必要があります。
  # config.clean_up_csrf_token_on_authentication = true

  # eager load時にルートを再読み込みしない場合はfalseに設定します。
  # config.reload_routes = true

  # ==> :database_authenticatable 設定
  # bcryptを使う場合のパスワードハッシュコストを設定します。デフォルトは12。
  # テスト環境ではパフォーマンス向上のため1に設定されます。
  config.stretches = Rails.env.test? ? 1 : 12

  # パスワードハッシュ生成に使用するペッパー（追加のソルト値）を設定します。
  # config.pepper = '4bdb0664...'

  # メールアドレス変更時に通知を送信するか。
  # config.send_email_changed_notification = false

  # パスワード変更時に通知メールを送信するか。
  # config.send_password_change_notification = false

  # ==> :confirmable 設定
  # アカウント確認をしていなくてもアクセス可能な期間を設定します。
  # config.allow_unconfirmed_access_for = 2.days

  # 確認メール送信後、トークンが無効になるまでの期間。
  # config.confirm_within = 3.days

  # メールアドレス変更時にも確認を必須にするか。
  config.reconfirmable = true

  # アカウント確認で使用するキー。
  # config.confirmation_keys = [:email]

  # ==> :rememberable 設定
  # ログイン情報を保持する期間。
  # config.remember_for = 2.weeks

  # サインアウト時にすべてのRemember Meトークンを無効化するか。
  config.expire_all_remember_me_on_sign_out = true

  # Cookieオプションを設定（例: secure: true でSSL専用クッキーにする）。
  # config.rememberable_options = {}

  # ==> :validatable 設定
  # パスワードの長さを設定。
  config.password_length = 6..128

  # メール形式のバリデーションに使用する正規表現。
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> :timeoutable 設定
  # 一定時間操作がない場合にセッションをタイムアウトする時間。
  # config.timeout_in = 30.minutes

  # ==> :lockable 設定
  # アカウントロックの戦略を設定。
  # :failed_attempts = 一定回数失敗したらロック
  # config.lock_strategy = :failed_attempts

  # アカウントロック解除に使うキー。
  # config.unlock_keys = [:email]

  # ロック解除の戦略（:email, :time, :both, :none）
  # config.unlock_strategy = :both

  # 最大認証試行回数。
  # config.maximum_attempts = 20

  # 一定時間経過後にロックを解除するまでの時間。
  # config.unlock_in = 1.hour

  # ロック前の最後の試行時に警告を表示するか。
  # config.last_attempt_warning = true

  # ==> :recoverable 設定
  # パスワードリセット用のキー。
  # config.reset_password_keys = [:email]

  # パスワードリセットリンクの有効期間。
  config.reset_password_within = 6.hours

  # パスワードリセット後に自動的にログインさせるか。デフォルトはtrue。
  # config.sign_in_after_reset_password = true

  # ==> :encryptable 設定
  # bcrypt以外のハッシュアルゴリズムを使う場合。
  # config.encryptor = :sha512

  # ==> スコープ設定
  # スコープごとのビューを有効にするか。デフォルトはfalse。
  # config.scoped_views = false

  # デフォルトのスコープを設定。
  # config.default_scope = :user

  # :sign_outが全スコープをサインアウトするかどうか。
  # config.sign_out_all_scopes = true

  # ==> ナビゲーション設定
  # ナビゲーションとして扱うレスポンスフォーマットを設定します。
  # config.navigational_formats = ['*/*', :html, :turbo_stream]

  # サインアウトのHTTPメソッドを設定します。デフォルトは :delete。
  config.sign_out_via = :delete

  # ==> OmniAuth 設定
  # 新しいOmniAuthプロバイダを追加します。
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden設定
  # Deviseでサポートされていない戦略を使用する場合などに設定します。
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> マウント可能なエンジン設定
  # Deviseをエンジン内で使用する場合の追加設定です。
  # config.router_name = :my_engine
  # config.omniauth_path_prefix = '/my_engine/users/auth'

  # ==> Hotwire/Turbo 設定
  # Hotwire/Turboを使用する際のエラーレスポンスやリダイレクトのHTTPステータスを設定します。
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> :registerable 設定
  # パスワード変更後に自動サインインさせるか。デフォルトはtrue。
  # config.sign_in_after_change_password = true
end

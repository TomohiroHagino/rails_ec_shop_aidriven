# frozen_string_literal: true

# セッションストアの設定（セキュリティ強化）
Rails.application.config.session_store :cookie_store,
  key: '_ec_shop_session',
  secure: Rails.env.production?,  # 本番環境ではHTTPSのみ
  httponly: true,                  # JavaScriptからのアクセスを防ぐ
  same_site: :lax,                 # CSRF対策
  expire_after: 2.hours            # 2時間後にセッション期限切れ


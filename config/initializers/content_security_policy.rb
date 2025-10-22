# frozen_string_literal: true

# Content Security Policy (CSP) の設定
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https
  policy.style_src   :self, :https
  # Nonce-based scriptの有効化（より安全）
  # policy.script_src :self, :https, :unsafe_inline
  # policy.style_src  :self, :https, :unsafe_inline
end

# CSPの違反をレポート（本番環境で有用）
# Rails.application.config.content_security_policy_report_only = true

# Nonceジェネレーターを有効化
Rails.application.config.content_security_policy_nonce_generator = ->(request) { 
  SecureRandom.base64(16) 
}

# NonceをCookieに保存しないようにする（よりセキュア）
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]

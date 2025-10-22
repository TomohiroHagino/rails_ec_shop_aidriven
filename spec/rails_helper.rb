# RSpec設定ファイル（rails generate rspec:install で生成）
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# 本番環境でのテスト実行を防止
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# spec/support/ 配下のサポートファイルを自動読み込み
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# 未実行のマイグレーションをチェックし、テスト実行前に適用
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # FactoryBotのメソッドを直接使用できるようにする
  config.include FactoryBot::Syntax::Methods

  # Fixtureのパス設定（使用しない場合は削除可能）
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # トランザクション内でテストを実行（各テスト後に自動ロールバック）
  config.use_transactional_fixtures = true

  # ファイルの場所からspecのタイプを自動推論
  config.infer_spec_type_from_file_location!

  # バックトレースからRails gemの行をフィルタリング
  config.filter_rails_from_backtrace!
end

# Shoulda Matchersの設定
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

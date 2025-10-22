# frozen_string_literal: true

# Deviseのヘルパーメソッドを使用できるようにする
RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  
  # Wardenのテストモードを有効化
  config.include Warden::Test::Helpers
  
  config.after :each do
    Warden.test_reset!
  end
end


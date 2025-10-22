# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "テストユーザー#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "Password123" }              # Devise用: 大文字、小文字、数字を含む
    password_confirmation { "Password123" }
  end
end


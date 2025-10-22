# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "テスト商品#{n}" }
    description { "これはテスト商品の説明です" }
    price { 1000 }
    stock_quantity { 10 }
  end
end


# frozen_string_literal: true

# シードデータを作成

# 既存のデータをクリア
puts "データをクリアしています..."
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Product.destroy_all
User.destroy_all

# ユーザーを作成
puts "ユーザーを作成しています..."
user1 = User.create!(
  name: "テスト太郎",
  email: "test@example.com",
  password: "Password123",           # 大文字、小文字、数字を含む
  password_confirmation: "Password123"
)

user2 = User.create!(
  name: "サンプル花子",
  email: "sample@example.com",
  password: "Password123",           # 大文字、小文字、数字を含む
  password_confirmation: "Password123"
)

puts "ユーザーを#{User.count}件作成しました"

# 商品を作成
puts "商品を作成しています..."
products = [
  {
    name: "Rubyプログラミング入門",
    description: "初心者から中級者向けのRubyプログラミング解説書。基礎から実践まで幅広くカバーしています。",
    price: 3200,
    stock_quantity: 50
  },
  {
    name: "Rails完全ガイド",
    description: "Ruby on Railsの完全ガイド。最新のRails 8に対応し、実践的な開発手法を学べます。",
    price: 4500,
    stock_quantity: 30
  },
  {
    name: "DDD実践入門",
    description: "ドメイン駆動設計の実践的な入門書。エンティティ、値オブジェクト、リポジトリパターンなどを詳しく解説。",
    price: 3800,
    stock_quantity: 25
  },
  {
    name: "クリーンアーキテクチャ",
    description: "ソフトウェアアーキテクチャの名著。保守性の高いコードを書くための原則を学べます。",
    price: 4200,
    stock_quantity: 40
  },
  {
    name: "テスト駆動開発",
    description: "TDDの基礎から実践まで。RSpecを使った効果的なテストの書き方を解説。",
    price: 3500,
    stock_quantity: 35
  },
  {
    name: "リファクタリング入門",
    description: "既存のコードを改善するためのリファクタリング技法を学べる一冊。",
    price: 3900,
    stock_quantity: 20
  },
  {
    name: "アジャイル開発実践ガイド",
    description: "スクラムやカンバンなど、アジャイル開発の実践的なガイド。チーム開発に必須。",
    price: 3600,
    stock_quantity: 45
  },
  {
    name: "データベース設計の基礎",
    description: "正規化から非正規化まで、データベース設計の基本を丁寧に解説。",
    price: 3300,
    stock_quantity: 30
  },
  {
    name: "RESTful API設計",
    description: "RESTful APIの設計原則とベストプラクティス。実務で役立つ内容が満載。",
    price: 4000,
    stock_quantity: 28
  },
  {
    name: "Git実践ガイド",
    description: "バージョン管理システムGitの使い方を基礎から応用まで学べる実践ガイド。",
    price: 2800,
    stock_quantity: 60
  }
]

products.each do |product_data|
  Product.create!(product_data)
end

puts "商品を#{Product.count}件作成しました"

puts "\nシードデータの作成が完了しました！"
puts "\nテストユーザー:"
puts "Email: test@example.com"
puts "Password: Password123"
puts "\nEmail: sample@example.com"
puts "Password: Password123"
puts "\n※パスワードは大文字、小文字、数字を含む8文字以上である必要があります"

# ECショップアプリ（DDD + レイヤードアーキテクチャ）

Ruby on Rails 8 と DDD（ドメイン駆動設計）で構築されたECショップアプリケーションです。

## 📖 概要

このアプリケーションは、ドメイン駆動設計（DDD）の原則に従って設計された、実践的なECショップアプリケーションです。
レイヤードアーキテクチャを採用し、ビジネスロジックをドメイン層に集約し、インフラストラクチャから分離しています。

### 主な機能

- ✅ ユーザー登録・認証
- ✅ 商品一覧・詳細表示
- ✅ ショッピングカート機能
- ✅ 注文処理
- ✅ 注文履歴表示

---

## 🏗 アーキテクチャ

### レイヤード構造

```
┌─────────────────────────────────┐
│     🎨 Presentation層            │  Controller、View
│  (app/controllers, app/views)   │
└─────────────────────────────────┘
              ↓
┌─────────────────────────────────┐
│     ⚙️ Application層             │  ユースケース（サービス）
│      (app/application)          │
└─────────────────────────────────┘
              ↓
┌─────────────────────────────────┐
│     💡 Domain層                   │  エンティティ、値オブジェクト
│       (app/domain)              │  リポジトリインターフェース
└─────────────────────────────────┘
              ↑
┌─────────────────────────────────┐
│     🗄️ Infrastructure層          │  リポジトリ実装、ActiveRecord
│   (app/infrastructure)          │
└─────────────────────────────────┘
```

### ディレクトリ構造

```
app/
├── domain/                          # ドメイン層
│   ├── user_aggregate/               # Userアグリゲートルート
│   │   ├── entity/
│   │   │   └── user_entity.rb      # ユーザーエンティティ
│   │   ├── value_object/
│   │   │   ├── user_id.rb          # ユーザーID値オブジェクト
│   │   │   └── email.rb            # メールアドレス値オブジェクト
│   │   └── repository/
│   │       └── user_repository.rb  # ユーザーリポジトリインターフェース
│   ├── product_aggregate/            # Productアグリゲートルート
│   │   ├── entity/
│   │   │   └── product_entity.rb
│   │   ├── value_object/
│   │   │   ├── product_id.rb
│   │   │   └── price.rb
│   │   └── repository/
│   │       └── product_repository.rb
│   ├── cart_aggregate/               # Cartアグリゲートルート
│   │   ├── entity/
│   │   │   └── cart_item_entity.rb
│   │   ├── value_object/
│   │   │   └── cart_item_id.rb
│   │   └── repository/
│   │       └── cart_repository.rb
│   └── order_aggregate/              # Orderアグリゲートルート
│       ├── entity/
│       │   ├── order_entity.rb
│       │   └── order_item_entity.rb
│       ├── value_object/
│       │   ├── order_id.rb
│       │   └── order_status.rb
│       └── repository/
│           └── order_repository.rb
│
├── application/                     # アプリケーション層（ユースケース）
│   ├── user_aggregate/
│   │   └── (ログイン認証機能はdeviseを使用)
│   │
│   ├── product_aggregate/
│   │   ├── list_products_service.rb
│   │   └── get_product_service.rb
│   ├── cart_aggregate/
│   │   ├── add_to_cart_service.rb
│   │   ├── get_cart_service.rb
│   │   └── remove_from_cart_service.rb
│   └── order_aggregate/
│       ├── create_order_service.rb
│       └── get_orders_service.rb
│
├── infrastructure/                  # インフラストラクチャ層
│   ├── user/
│   │   └── repository/
│   │       └── user_repository_impl.rb
│   ├── product/
│   │   └── repository/
│   │       └── product_repository_impl.rb
│   ├── cart/
│   │   └── repository/
│   │       └── cart_repository_impl.rb
│   └── order/
│       └── repository/
│           └── order_repository_impl.rb
│
├── models/                          # ActiveRecordモデル（Infrastructure層で使用）
│   ├── user.rb
│   ├── product.rb
│   ├── cart_item.rb
│   ├── order.rb
│   └── order_item.rb
│
├── controllers/                     # Presentation層
│   ├── application_controller.rb
│   ├── home_controller.rb
│   ├── users/
│   │   └── registrations_controller.rb
│   ├── products_controller.rb
│   ├── cart_items_controller.rb
│   └── orders_controller.rb
│
└── views/                           # ビューテンプレート
    ├── layouts/
    │   └── application.html.erb
    ├── home/
    ├── users/
    │   ├── sessions/
    │   │   └── new.html.erb
    │   └── registrations/
    │       └── new.html.erb
    ├── products/
    ├── cart_items/
    └── orders/
```

### レイヤー間の依存関係

```
🎨 Presentation
        ↓
⚙️ Application
        ↓
💡 Domain
        ↑
🗄️ Infrastructure
```

**ルール**:
- Presentation層はApplication層を呼び出す
- Application層はDomain層のみに依存
- Domain層は他の層に依存しない（純粋なビジネスロジック）
- Infrastructure層はDomain層のインターフェースを実装

---

## 🚀 セットアップ

### 必要要件

- Ruby 3.4.1
- Rails 8.0
- SQLite3
- Bundler

### インストール手順

```bash
# リポジトリをクローン
git clone <repository-url>
cd ec_shop_aidriven

# 依存パッケージをインストール
bundle install

# データベースを作成してマイグレーション
rails db:create db:migrate

# シードデータを投入
rails db:seed

# サーバー起動
rails server
```

ブラウザで `http://localhost:3000` にアクセスしてください。

---

## 🎮 アプリケーションの起動

### 開発サーバー起動

```bash
# Railsサーバー起動
rails server
```

`http://localhost:3000` にアクセス

### テストユーザー

シードデータで以下のテストユーザーが作成されます：

- **Email**: `test@example.com`
- **Password**: `Password123`

または

- **Email**: `sample@example.com`
- **Password**: `Password123`

**注意**: パスワードは大文字、小文字、数字を含む8文字以上である必要があります。

---

## 📝 使い方

### 1. ユーザー登録

1. トップページの「新規登録」をクリック
2. 名前、メールアドレス、パスワードを入力
   - **パスワード要件**: 8文字以上、大文字・小文字・数字を含む
   - 例: `Password123`
3. パスワード確認を入力
4. 「登録」ボタンをクリック
5. 自動的にログインされ、商品一覧ページへ遷移

### 2. 商品閲覧

1. 「商品一覧」ページで在庫のある商品を閲覧
2. 商品をクリックして詳細を確認
3. 「カートへ」ボタンでカートに追加

### 3. カート管理

1. ヘッダーの「カート」をクリック
2. カート内の商品を確認
3. 不要な商品は「削除」ボタンで削除可能
4. 「注文を確定する」ボタンで注文を作成

### 4. 注文履歴

1. ヘッダーの「注文履歴」をクリック
2. 過去の注文を確認
3. 各注文の詳細（商品、数量、金額、ステータス）を表示

---

## 🧪 テスト

RSpecを使用したテストフレームワークを採用しています。

```bash
# 全テスト実行
bundle exec rspec

# 特定のテストを実行
bundle exec rspec spec/domain/user/entity/user_entity_spec.rb
```

---

## 🛠 技術スタック

- **Framework**: Ruby on Rails 8.0
- **Language**: Ruby 3.4.1
- **Database**: SQLite3
- **Authentication**: Devise (セキュア認証)
  - パスワード暗号化（BCrypt）
  - セッション管理
  - Remember me機能
  - パスワードリセット機能
  - セッション固定攻撃対策
- **Testing**: RSpec 7.0
  - FactoryBot (テストデータ作成)
  - Database Cleaner (データベースクリーニング)
  - Shoulda Matchers (マッチャー)
- **Asset Pipeline**: Propshaft + Dart Sass
- **CSS**: BEM方式
- **Responsive Design**: モバイル、タブレット、デスクトップ対応
- **Architecture**: DDD + Layered Architecture

---

## 🔑 主要な設計パターン

### 1. Aggregate Pattern

**OrderEntity** が **OrderItemEntity** を集約し、整合性を保証します。
各ドメインは明確にアグリゲートルートとして設計されています：

- **UserAggregate**: ユーザー情報の整合性を保証
- **ProductAggregate**: 商品情報の整合性を保証  
- **CartAggregate**: カートアイテムの整合性を保証
- **OrderAggregate**: 注文と注文明細の整合性を保証

### 2. Repository Pattern

データアクセスを抽象化し、Domain層をインフラストラクチャから分離しています。

### 3. Value Object

**Email**、**Price**、**OrderStatus** などの不変の値オブジェクトでドメインルールをカプセル化しています。

### 4. Application Service (Use Case)

各ユースケースを1つのトランザクション単位で実装しています。

例：
- `ListProductsService`: 商品一覧取得
- `AddToCartService`: カート追加
- `CreateOrderService`: 注文作成

### 5. Dependency Injection

コンストラクタインジェクションによる疎結合を実現しています。
---

## 🤔 「2つのモデル」問題の解決

このアプリケーションでは、**ActiveRecord Model** と **Domain Entity** が共存しています。

### ActiveRecord Model（Infrastructure層）

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Deviseによる認証機能
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
end
```

### Domain Entity（Domain層）

```ruby
# app/domain/user_aggregate/entity/user_entity.rb
class UserEntity
  # ビジネスロジック専用
  def change_email(new_email)
    # ドメインルールを実装
  end
end
```

### 変換はRepository実装で行う

```ruby
# app/infrastructure/user/repository/user_repository_impl.rb
def to_entity(user)
  Domain::UserAggregate::Entity::UserEntity.new(
    id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
    name: user.name,
    email: Domain::UserAggregate::ValueObject::Email.new(user.email),
    password_digest: user.encrypted_password
  )
end
```

---

## 📊 データベース設計

### テーブル構造

- **users**: ユーザー情報
- **products**: 商品情報
- **cart_items**: カートアイテム
- **orders**: 注文情報
- **order_items**: 注文明細

---

## 🔒 セキュリティ機能

### Deviseによる認証セキュリティ

1. **パスワード暗号化**: BCryptによる強力なハッシュ化
2. **セッション固定攻撃対策**: ログイン時にセッションIDを自動再生成
3. **セッション有効期限**: 2時間で自動ログアウト
4. **Remember me機能**: 安全な永続ログイン
5. **パスワードリセット**: トークンベースの安全なリセット機能

### 強力なパスワードポリシー

- 最低8文字以上
- 大文字を含む（A-Z）
- 小文字を含む（a-z）
- 数字を含む（0-9）

### セキュリティヘッダー

- `X-Frame-Options: SAMEORIGIN` - クリックジャッキング対策
- `X-Content-Type-Options: nosniff` - MIMEタイプスニッフィング対策
- `X-XSS-Protection: 1; mode=block` - XSS対策
- CSRF保護が有効

### Cookie設定

- `httponly: true` - JavaScriptからのアクセス防止
- `same_site: :lax` - CSRF対策
- `secure: true`（本番環境のみ） - HTTPS通信のみ

---

## 📚 参考資料

- [Domain-Driven Design by Eric Evans](https://www.amazon.co.jp/dp/0321125215)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Clean Architecture by Robert C. Martin](https://www.amazon.co.jp/dp/4048930656)

---

## 🎨 レスポンシブデザイン

### サポートするデバイス

- 📱 **モバイル** (〜768px): スマートフォン最適化
- 📱 **タブレット** (769px〜1024px): タブレット最適化  
- 🖥 **デスクトップ** (1025px〜): PC最適化

### モバイル対応の特徴

- ✅ 固定ヘッダー（画面スクロール時も表示）
- ✅ タッチフレンドリーなボタンサイズ（最小44px）
- ✅ 1カラムレイアウト
- ✅ 読みやすいフォントサイズ
- ✅ iOSズーム防止（input要素は16px以上）
- ✅ レスポンシブグリッド

---

## 🎯 今後の拡張案

- [ ] 管理画面の追加（商品登録・編集・削除）
- [ ] 商品カテゴリ機能
- [ ] 商品検索機能
- [ ] レビュー機能
- [ ] お気に入り機能
- [ ] 注文ステータスの更新（確定、発送、配達完了）
- [ ] 決済機能の統合
- [ ] API化（RESTful API）
- [ ] Event Sourcing導入
- [ ] CQRS パターン適用
- [ ] ダークモード対応

---

## 📄 ライセンス

MIT License

---

Made with ❤️ using Ruby on Rails & DDD

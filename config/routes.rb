Rails.application.routes.draw do
  get '/.well-known/appspecific/com.chrome.devtools.json', to: proc { [204, {}, ['']] }

  # ルートページ
  root 'home#index'

  # Devise認証（カスタムコントローラーを使用）
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'signup'
  }

  # 商品
  resources :products, only: [:index, :show]

  # カート
  resources :cart_items, only: [:index, :create, :destroy]

  # 注文
  resources :orders, only: [:index, :create]

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end

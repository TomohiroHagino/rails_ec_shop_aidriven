# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # セキュリティヘッダーを追加
  before_action :set_security_headers

  # Deviseのヘルパーメソッド
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user, :logged_in?

  private

  # Deviseのcurrent_userをDomainエンティティに変換
  def current_user
    # メモ化済みなら即座に返す
    return @current_user if instance_variable_defined?(:@current_user)
    
    # Wardenから直接取得（user_signed_in?を使わない）
    devise_user = warden.authenticate(scope: :user)
    return @current_user = nil unless devise_user

    @current_user = begin
      user_repository = Infrastructure::User::Repository::UserRepositoryImpl.new
      user_id = Domain::User::ValueObject::UserId.new(devise_user.id)
      user_repository.find(user_id)
    end
  end

  # ログイン状態をチェック
  def logged_in?
    warden.authenticated?(:user)
  end

  # ログインを必須にする
  def require_login
    unless logged_in?
      flash[:alert] = 'ログインしてください'
      redirect_to new_user_session_path
    end
  end

  # セキュリティヘッダーを設定
  def set_security_headers
    # クリックジャッキング対策
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    # XSS対策
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end

  # Deviseの許可パラメータを設定（グローバル）
  def configure_permitted_parameters
    return unless devise_controller?
    
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

# frozen_string_literal: true

module Users
  # Deviseのセッションコントローラーをカスタマイズ
  class SessionsController < Devise::SessionsController
    # ログインフォーム表示（既存のビューを使用）
    # def new
    #   super
    # end

    # ログイン処理（Deviseのデフォルト処理を使用）
    # def create
    #   super
    # end

    # ログアウト処理（Deviseのデフォルト処理を使用）
    # def destroy
    #   super
    # end

    protected

    # ログイン後のリダイレクト先
    def after_sign_in_path_for(resource)
      products_path
    end

    # ログアウト後のリダイレクト先
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
  end
end


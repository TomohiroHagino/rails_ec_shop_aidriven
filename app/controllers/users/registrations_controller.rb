# frozen_string_literal: true

module Users
  # Deviseの登録コントローラーをカスタマイズ
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    # 新規登録フォーム表示（既存のビューを使用）
    def new
      super
    end

    # ユーザー登録処理（エラー時は登録フォームを再表示）
    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    protected

    # 登録時に許可するパラメータ（nameを追加）
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    # 登録後のリダイレクト先
    def after_sign_up_path_for(resource)
      products_path
    end
  end
end


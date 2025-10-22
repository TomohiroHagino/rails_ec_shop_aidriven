# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup' do
    it '新規登録ページが表示される' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /signup' do
    context '正常な登録の場合' do
      it 'ユーザーが作成される' do
        expect do
          post user_registration_path, params: {
            user: {
              name: 'テストユーザー',
              email: 'new@example.com',
              password: 'Password123',
              password_confirmation: 'Password123'
            }
          }
        end.to change(User, :count).by(1)
      end

      it '商品一覧ページにリダイレクトされる' do
        post user_registration_path, params: {
          user: {
            name: 'テストユーザー',
            email: 'new@example.com',
            password: 'Password123',
            password_confirmation: 'Password123'
          }
        }
        expect(response).to redirect_to(products_path)
      end
    end

    context 'メールアドレスが重複している場合' do
      before do
        create(:user, email: 'duplicate@example.com')
      end

      it 'エラーメッセージが表示される' do
        post user_registration_path, params: {
          user: {
            name: 'テストユーザー',
            email: 'duplicate@example.com',
            password: 'Password123',
            password_confirmation: 'Password123'
          }
        }
        expect(response).to have_http_status(:unprocessable_content) # Rails 8では422を返す
      end
    end

    context 'パスワードが弱い場合' do
      it 'エラーメッセージが表示される' do
        post user_registration_path, params: {
          user: {
            name: 'テストユーザー',
            email: 'new@example.com',
            password: 'password',  # 大文字と数字がない
            password_confirmation: 'password'
          }
        }
        expect(response).to have_http_status(:unprocessable_content) # Rails 8では422を返す
      end
    end
  end
end


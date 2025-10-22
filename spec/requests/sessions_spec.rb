# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user, email: 'test@example.com', password: 'Password123') }

  describe 'GET /login' do
    it 'ログインページが表示される' do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    context '正しいメールアドレスとパスワードの場合' do
      it 'ログインできる' do
        post user_session_path, params: {
          user: {
            email: 'test@example.com',
            password: 'Password123'
          }
        }
        expect(response).to redirect_to(products_path)
      end

      it '商品一覧ページにリダイレクトされる' do
        post user_session_path, params: {
          user: {
            email: 'test@example.com',
            password: 'Password123'
          }
        }
        expect(response).to redirect_to(products_path)
      end
    end

    context 'パスワードが間違っている場合' do
      it 'エラーメッセージが表示される' do
        post user_session_path, params: {
          user: {
            email: 'test@example.com',
            password: 'wrong_password'
          }
        }
        expect(response).to have_http_status(:unprocessable_content) # Rails 8では422を返す
      end
    end
  end

  describe 'DELETE /logout' do
    before do
      sign_in user, scope: :user
    end

    it 'ログアウトできる' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end

    it 'ルートページにリダイレクトされる' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end


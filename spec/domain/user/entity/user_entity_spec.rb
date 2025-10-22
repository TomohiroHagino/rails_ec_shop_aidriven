# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::User::Entity::UserEntity do
  let(:user_id) { Domain::User::ValueObject::UserId.new(1) }
  let(:email) { Domain::User::ValueObject::Email.new('test@example.com') }
  let(:user) do
    described_class.new(
      id: user_id,
      name: 'テストユーザー',
      email: email,
      password_digest: 'hashed_password'
    )
  end

  describe '#initialize' do
    it 'ユーザーエンティティが作成される' do
      expect(user.id).to eq(user_id)
      expect(user.name).to eq('テストユーザー')
      expect(user.email).to eq(email)
      expect(user.password_digest).to eq('hashed_password')
    end
  end

  describe '#change_name' do
    it '名前を変更できる' do
      user.change_name('新しい名前')
      expect(user.name).to eq('新しい名前')
    end

    it '空の名前は設定できない' do
      expect { user.change_name('') }.to raise_error(ArgumentError, '名前が空です')
    end

    it 'nilの名前は設定できない' do
      expect { user.change_name(nil) }.to raise_error(ArgumentError, '名前が空です')
    end
  end

  describe '#change_email' do
    it 'メールアドレスを変更できる' do
      new_email = Domain::User::ValueObject::Email.new('new@example.com')
      user.change_email(new_email)
      expect(user.email).to eq(new_email)
    end

    it 'Email値オブジェクト以外は設定できない' do
      expect { user.change_email('invalid') }.to raise_error(ArgumentError, 'メールアドレスが空です')
    end
  end

  describe '#change_password' do
    it 'パスワードを変更できる' do
      user.change_password('new_hashed_password')
      expect(user.password_digest).to eq('new_hashed_password')
    end

    it '空のパスワードは設定できない' do
      expect { user.change_password('') }.to raise_error(ArgumentError, 'パスワードが空です')
    end
  end

  describe '等価性' do
    it '同じIDのユーザーは等しい' do
      user1 = described_class.new(
        id: user_id,
        name: '名前1',
        email: email,
        password_digest: 'password1'
      )
      user2 = described_class.new(
        id: user_id,
        name: '名前2',
        email: email,
        password_digest: 'password2'
      )
      expect(user1).to eq(user2)
    end

    it '異なるIDのユーザーは等しくない' do
      user1 = described_class.new(
        id: Domain::User::ValueObject::UserId.new(1),
        name: 'テスト',
        email: email,
        password_digest: 'password'
      )
      user2 = described_class.new(
        id: Domain::User::ValueObject::UserId.new(2),
        name: 'テスト',
        email: email,
        password_digest: 'password'
      )
      expect(user1).not_to eq(user2)
    end
  end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::User::ValueObject::Email do
  describe '#initialize' do
    context '正常なメールアドレスの場合' do
      it 'インスタンスが作成される' do
        email = described_class.new('test@example.com')
        expect(email.value).to eq('test@example.com')
      end

      it 'メールアドレスが小文字に変換される' do
        email = described_class.new('TEST@EXAMPLE.COM')
        expect(email.value).to eq('test@example.com')
      end
    end

    context '不正なメールアドレスの場合' do
      it 'nilの場合はエラーが発生する' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError, 'メールアドレスが空です')
      end

      it '空文字の場合はエラーが発生する' do
        expect { described_class.new('') }.to raise_error(ArgumentError, 'メールアドレスが空です')
      end

      it '形式が不正な場合はエラーが発生する' do
        expect { described_class.new('invalid') }.to raise_error(ArgumentError, 'メールアドレスの形式が不正です')
      end
    end
  end

  describe '等価性' do
    it '同じメールアドレスの場合は等しい' do
      email1 = described_class.new('test@example.com')
      email2 = described_class.new('test@example.com')
      expect(email1).to eq(email2)
    end

    it '異なるメールアドレスの場合は等しくない' do
      email1 = described_class.new('test1@example.com')
      email2 = described_class.new('test2@example.com')
      expect(email1).not_to eq(email2)
    end
  end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::Order::ValueObject::OrderStatus do
  describe '#initialize' do
    context '正常なステータスの場合' do
      it 'pendingステータスが作成される' do
        status = described_class.new('pending')
        expect(status.value).to eq('pending')
      end

      it 'confirmedステータスが作成される' do
        status = described_class.new('confirmed')
        expect(status.value).to eq('confirmed')
      end
    end

    context '不正なステータスの場合' do
      it 'nilの場合はエラーが発生する' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError, 'ステータスが空です')
      end

      it '無効なステータスの場合はエラーが発生する' do
        expect { described_class.new('invalid_status') }.to raise_error(ArgumentError, /無効なステータスです/)
      end
    end
  end

  describe 'ステータス判定メソッド' do
    it '#pending?でpendingステータスを判定できる' do
      status = described_class.new('pending')
      expect(status.pending?).to be true
      expect(status.confirmed?).to be false
    end

    it '#confirmed?でconfirmedステータスを判定できる' do
      status = described_class.new('confirmed')
      expect(status.confirmed?).to be true
      expect(status.pending?).to be false
    end

    it '#shipped?でshippedステータスを判定できる' do
      status = described_class.new('shipped')
      expect(status.shipped?).to be true
    end

    it '#delivered?でdeliveredステータスを判定できる' do
      status = described_class.new('delivered')
      expect(status.delivered?).to be true
    end

    it '#cancelled?でcancelledステータスを判定できる' do
      status = described_class.new('cancelled')
      expect(status.cancelled?).to be true
    end
  end
end


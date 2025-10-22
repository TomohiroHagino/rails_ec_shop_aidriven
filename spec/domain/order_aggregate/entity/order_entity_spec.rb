# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::OrderAggregate::Entity::OrderEntity do
  let(:order_id) { Domain::OrderAggregate::ValueObject::OrderId.new(1) }
  let(:user_id) { Domain::UserAggregate::ValueObject::UserId.new(1) }
  let(:total_amount) { Domain::ProductAggregate::ValueObject::Price.new(5000) }
  let(:status) { Domain::OrderAggregate::ValueObject::OrderStatus.new('pending') }
  let(:order) do
    described_class.new(
      id: order_id,
      user_id: user_id,
      total_amount: total_amount,
      status: status
    )
  end

  describe '#initialize' do
    it '注文エンティティが作成される' do
      expect(order.id).to eq(order_id)
      expect(order.user_id).to eq(user_id)
      expect(order.total_amount).to eq(total_amount)
      expect(order.status).to eq(status)
    end

    it 'ユーザーIDが空の場合はエラーが発生する' do
      expect do
        described_class.new(
          id: order_id,
          user_id: nil,
          total_amount: total_amount,
          status: status
        )
      end.to raise_error(ArgumentError, 'ユーザーIDが空です')
    end
  end

  describe '#confirm' do
    it 'pendingステータスからconfirmedステータスに変更できる' do
      order.confirm
      expect(order.status.confirmed?).to be true
    end

    it 'pending以外のステータスからは確定できない' do
      order.confirm
      expect { order.confirm }.to raise_error(ArgumentError, '確定できません')
    end
  end

  describe '#ship' do
    it 'confirmedステータスからshippedステータスに変更できる' do
      order.confirm
      order.ship
      expect(order.status.shipped?).to be true
    end

    it 'confirmed以外のステータスからは出荷できない' do
      expect { order.ship }.to raise_error(ArgumentError, '出荷できません')
    end
  end

  describe '#deliver' do
    it 'shippedステータスからdeliveredステータスに変更できる' do
      order.confirm
      order.ship
      order.deliver
      expect(order.status.delivered?).to be true
    end

    it 'shipped以外のステータスからは配達完了できない' do
      expect { order.deliver }.to raise_error(ArgumentError, '配達完了できません')
    end
  end

  describe '#cancel' do
    it 'pendingステータスからキャンセルできる' do
      order.cancel
      expect(order.status.cancelled?).to be true
    end

    it 'confirmedステータスからキャンセルできる' do
      order.confirm
      order.cancel
      expect(order.status.cancelled?).to be true
    end

    it 'deliveredステータスからはキャンセルできない' do
      order.confirm
      order.ship
      order.deliver
      expect { order.cancel }.to raise_error(ArgumentError, 'キャンセルできません')
    end
  end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::OrderAggregate::CancelStaleOrdersService do
  let(:order_repository) { double('OrderRepository') }
  let(:service) { described_class.new(order_repository: order_repository) }
  let(:user) { create(:user) }

  describe '#execute' do
    context '期限切れのpending注文がある場合' do
      let(:stale_order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 8.days.ago
        )
      end

      let(:cancelled_order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('cancelled'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 8.days.ago,
          updated_at: Time.current
        )
      end

      before do
        allow(order_repository).to receive(:find_stale_pending_orders).and_return([stale_order])
        allow(order_repository).to receive(:save).and_return(cancelled_order)
      end

      it '期限切れ注文をキャンセルする' do
        result = service.execute

        expect(result[:cancelled_count]).to eq(1)
        expect(result[:total_processed]).to eq(1)
        expect(result[:errors]).to be_empty
      end

      it '注文ステータスがcancelledに変更される' do
        service.execute

        expect(order_repository).to have_received(:save).with(
          an_object_having_attributes(
            status: Domain::OrderAggregate::ValueObject::OrderStatus.new('cancelled')
          )
        )
      end

      it 'カスタム日数で実行できる' do
        result = service.execute(days_ago: 14)

        expect(order_repository).to have_received(:find_stale_pending_orders).with(
          be_within(1.second).of(14.days.ago.beginning_of_day)
        )
      end
    end

    context '期限切れのpending注文がない場合' do
      before do
        allow(order_repository).to receive(:find_stale_pending_orders).and_return([])
      end

      it '何も処理されない' do
        result = service.execute

        expect(result[:cancelled_count]).to eq(0)
        expect(result[:total_processed]).to eq(0)
        expect(result[:errors]).to be_empty
      end
    end

    context '複数の期限切れ注文がある場合' do
      let(:stale_order1) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 8.days.ago
        )
      end

      let(:stale_order2) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(2),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(2000),
          created_at: 10.days.ago
        )
      end

      before do
        allow(order_repository).to receive(:find_stale_pending_orders).and_return([stale_order1, stale_order2])
        allow(order_repository).to receive(:save).and_return(stale_order1, stale_order2)
      end

      it 'すべての期限切れ注文をキャンセルする' do
        result = service.execute

        expect(result[:cancelled_count]).to eq(2)
        expect(result[:total_processed]).to eq(2)
        expect(result[:errors]).to be_empty
      end
    end

    context '注文の保存でエラーが発生した場合' do
      let(:stale_order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 8.days.ago
        )
      end

      before do
        allow(order_repository).to receive(:find_stale_pending_orders).and_return([stale_order])
        allow(order_repository).to receive(:save).and_raise(StandardError, 'Database error')
      end

      it 'エラーが記録される' do
        result = service.execute

        expect(result[:cancelled_count]).to eq(0)
        expect(result[:total_processed]).to eq(1)
        expect(result[:errors]).to include('注文ID 1 のキャンセルに失敗: Database error')
      end

      it '他の注文の処理は続行される' do
        stale_order2 = Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(2),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(2000),
          created_at: 8.days.ago
        )

        allow(order_repository).to receive(:find_stale_pending_orders).and_return([stale_order, stale_order2])
        
        # 1回目の呼び出しでエラー、2回目の呼び出しで成功
        call_count = 0
        allow(order_repository).to receive(:save) do |order|
          call_count += 1
          if call_count == 1
            raise StandardError, 'Database error'
          else
            stale_order2
          end
        end

        result = service.execute

        expect(result[:cancelled_count]).to eq(1)
        expect(result[:total_processed]).to eq(2)
        expect(result[:errors].size).to eq(1)
      end
    end

    context 'dry_runモードのテスト' do
      let(:stale_order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 8.days.ago
        )
      end

      before do
        allow(order_repository).to receive(:find_stale_pending_orders).and_return([stale_order])
        allow(order_repository).to receive(:save)
      end

      it 'dry_runモードでは実際にキャンセルされない' do
        result = service.execute(dry_run: true)

        expect(result[:cancelled_count]).to eq(1)
        expect(result[:dry_run]).to be true
        expect(order_repository).not_to have_received(:save)
      end

      it 'dry_runモードではDRY RUNログが出力される' do
        expect(Rails.logger).to receive(:info).with('[DRY RUN] 注文ID 1 をキャンセル対象としました（実際にはキャンセルしません）')

        service.execute(dry_run: true)
      end

      it 'dry_runがfalseの場合は通常通りキャンセルされる' do
        allow(order_repository).to receive(:save)

        result = service.execute(dry_run: false)

        expect(result[:cancelled_count]).to eq(1)
        expect(result[:dry_run]).to be false
        expect(order_repository).to have_received(:save)
      end
    end

    context 'ログ出力のテスト' do
      let(:stale_order) do
        Domain::OrderAggregate::Entity::OrderEntity.new(
          id: Domain::OrderAggregate::ValueObject::OrderId.new(1),
          user_id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
          status: Domain::OrderAggregate::ValueObject::OrderStatus.new('pending'),
          total_amount: Domain::ProductAggregate::ValueObject::Price.new(1000),
          created_at: 8.days.ago
        )
      end

      before do
        allow(order_repository).to receive(:find_stale_pending_orders).and_return([stale_order])
        allow(order_repository).to receive(:save).and_return(stale_order)
      end

      it '成功時にログが出力される' do
        expect(Rails.logger).to receive(:info).with('注文ID 1 をキャンセルしました')

        service.execute
      end

      it 'エラー時にログが出力される' do
        allow(order_repository).to receive(:save).and_raise(StandardError, 'Database error')
        expect(Rails.logger).to receive(:error).with('注文ID 1 のキャンセルに失敗: Database error')

        service.execute
      end
    end
  end
end

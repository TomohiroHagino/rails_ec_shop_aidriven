# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::CartAggregate::RemoveFromCartService do
  let(:cart_repository) { double('CartRepository') }
  let(:service) { described_class.new(cart_repository: cart_repository) }

  describe '#execute' do
    context '正常にカートアイテムを削除する場合' do
      before do
        allow(cart_repository).to receive(:delete).and_return(true)
      end

      it 'カートアイテムが削除される' do
        result = service.execute(cart_item_id: 1)

        expect(result).to be true
        expect(cart_repository).to have_received(:delete).with(
          Domain::CartAggregate::ValueObject::CartItemId.new(1)
        )
      end

      it 'CartItemIdのValueObjectが正しく作成される' do
        service.execute(cart_item_id: 123)

        expect(cart_repository).to have_received(:delete).with(
          Domain::CartAggregate::ValueObject::CartItemId.new(123)
        )
      end
    end

    context 'カートアイテムが見つからない場合' do
      before do
        allow(cart_repository).to receive(:delete).and_return(false)
      end

      it 'falseを返す' do
        result = service.execute(cart_item_id: 999)

        expect(result).to be false
      end
    end

    context '無効なIDが渡された場合' do
      it 'nilのIDでエラーが発生する' do
        expect { service.execute(cart_item_id: nil) }.to raise_error(
          ArgumentError, 'カートアイテムIDが空です'
        )
      end

      it '文字列のIDは整数に変換される' do
        allow(cart_repository).to receive(:delete).and_return(true)

        result = service.execute(cart_item_id: '1')

        expect(result).to be true
        expect(cart_repository).to have_received(:delete).with(
          Domain::CartAggregate::ValueObject::CartItemId.new(1)
        )
      end
    end

    context 'リポジトリでエラーが発生した場合' do
      before do
        allow(cart_repository).to receive(:delete).and_raise(StandardError, 'Database error')
      end

      it 'エラーが再発生する' do
        expect { service.execute(cart_item_id: 1) }.to raise_error(StandardError, 'Database error')
      end
    end
  end
end

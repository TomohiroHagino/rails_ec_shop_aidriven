# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::ProductAggregate::ValueObject::Price do
  describe '#initialize' do
    context '正常な価格の場合' do
      it 'インスタンスが作成される' do
        price = described_class.new(1000)
        expect(price.value).to eq(BigDecimal('1000'))
      end

      it '0円も設定できる' do
        price = described_class.new(0)
        expect(price.value).to eq(BigDecimal('0'))
      end

      it '文字列の数値も受け付ける' do
        price = described_class.new('1500')
        expect(price.value).to eq(BigDecimal('1500'))
      end
    end

    context '不正な価格の場合' do
      it 'nilの場合はエラーが発生する' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError, '価格が空です')
      end

      it '負の値の場合はエラーが発生する' do
        expect { described_class.new(-100) }.to raise_error(ArgumentError, '価格は0以上である必要があります')
      end
    end
  end

  describe '等価性' do
    it '同じ価格の場合は等しい' do
      price1 = described_class.new(1000)
      price2 = described_class.new(1000)
      expect(price1).to eq(price2)
    end

    it '異なる価格の場合は等しくない' do
      price1 = described_class.new(1000)
      price2 = described_class.new(2000)
      expect(price1).not_to eq(price2)
    end
  end

  describe '変換メソッド' do
    let(:price) { described_class.new(1234) }

    it '#to_fで浮動小数点数に変換できる' do
      expect(price.to_f).to eq(1234.0)
    end

    it '#to_iで整数に変換できる' do
      expect(price.to_i).to eq(1234)
    end

    it '#to_sで文字列に変換できる' do
      expect(price.to_s).to eq('1234.0')
    end
  end
end


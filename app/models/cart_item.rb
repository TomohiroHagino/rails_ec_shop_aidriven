# frozen_string_literal: true

# カートアイテムのActiveRecordモデル（Infrastructure層で使用）
class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end


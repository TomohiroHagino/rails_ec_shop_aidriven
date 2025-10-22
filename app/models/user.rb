# frozen_string_literal: true

# ユーザーのActiveRecordモデル（Deviseを使用）
class User < ApplicationRecord
  # Deviseモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  # Deviseのデフォルトのパスワードバリデーションを上書き
  # （より強力なパスワードポリシー）
  validate :password_complexity

  private

  def password_complexity
    return if password.blank?

    # 最低8文字
    if password.length < 8
      errors.add :password, 'は8文字以上である必要があります'
    end

    # 大文字、小文字、数字を含む
    unless password.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      errors.add :password, 'は大文字、小文字、数字を含む必要があります'
    end
  end
end


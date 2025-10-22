# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :user
    total_amount { 1000 }
    status { 'pending' }
  end
end


# frozen_string_literal: true

module Domain
  module UserAggregate
    module ValueObject
      # メールアドレスを表す値オブジェクト
      class Email
        EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

        attr_reader :value

        def initialize(value)
          raise ArgumentError, 'メールアドレスが空です' if value.nil? || value.empty?
          raise ArgumentError, 'メールアドレスの形式が不正です' unless value.match?(EMAIL_REGEX)

          @value = value.downcase
        end

        def ==(other)
          return false unless other.is_a?(Email)

          value == other.value
        end

        alias eql? ==

        def hash
          value.hash
        end

        def to_s
          value
        end
      end
    end
  end
end


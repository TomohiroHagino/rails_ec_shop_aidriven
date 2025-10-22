# frozen_string_literal: true

module Domain
  module UserAggregate
    module Entity
      # ユーザーエンティティ（Aggregate Root）
      class UserEntity
        attr_reader :id, :name, :email, :password_digest, :created_at, :updated_at

        def initialize(id:, name:, email:, password_digest:, created_at: nil, updated_at: nil)
          @id = id
          @name = name
          @email = email
          @password_digest = password_digest
          @created_at = created_at
          @updated_at = updated_at
        end

        # 名前を変更
        def change_name(new_name)
          raise ArgumentError, '名前が空です' if new_name.nil? || new_name.empty?

          @name = new_name
          @updated_at = Time.current
        end

        # メールアドレスを変更
        def change_email(new_email)
          raise ArgumentError, 'メールアドレスが空です' unless new_email.is_a?(ValueObject::Email)

          @email = new_email
          @updated_at = Time.current
        end

        # パスワードを変更
        def change_password(new_password_digest)
          raise ArgumentError, 'パスワードが空です' if new_password_digest.nil? || new_password_digest.empty?

          @password_digest = new_password_digest
          @updated_at = Time.current
        end

        def ==(other)
          return false unless other.is_a?(UserEntity)

          id == other.id
        end

        alias eql? ==

        def hash
          id.hash
        end
      end
    end
  end
end


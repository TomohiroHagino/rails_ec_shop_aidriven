# frozen_string_literal: true

module Domain
  module UserAggregate
    module Repository
      # ユーザーリポジトリのインターフェース
      class UserRepository
        # IDでユーザーを検索
        # @param id [ValueObject::UserId]
        # @return [Entity::UserEntity, nil]
        def find(id)
          raise NotImplementedError
        end

        # メールアドレスでユーザーを検索
        # @param email [ValueObject::Email]
        # @return [Entity::UserEntity, nil]
        def find_by_email(email)
          raise NotImplementedError
        end

        # すべてのユーザーを取得
        # @return [Array<Entity::UserEntity>]
        def all
          raise NotImplementedError
        end

        # ユーザーを保存
        # @param user [Entity::UserEntity]
        # @return [Entity::UserEntity]
        def save(user)
          raise NotImplementedError
        end

        # ユーザーを削除
        # @param id [ValueObject::UserId]
        # @return [Boolean]
        def delete(id)
          raise NotImplementedError
        end
      end
    end
  end
end


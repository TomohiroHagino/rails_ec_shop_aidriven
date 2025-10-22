# frozen_string_literal: true

module Infrastructure
  module User
    module Repository
      # ユーザーリポジトリの実装（ActiveRecord使用）
      class UserRepositoryImpl < Domain::UserAggregate::Repository::UserRepository
        # IDでユーザーを検索
        def find(id)
          user = ::User.find_by(id: id.value)
          return nil unless user

          to_entity(user)
        end

        # メールアドレスでユーザーを検索
        def find_by_email(email)
          user = ::User.find_by(email: email.value)
          return nil unless user

          to_entity(user)
        end

        # すべてのユーザーを取得
        def all
          ::User.all.map { |user| to_entity(user) }
        end

        # ユーザーを保存
        def save(user)
          if user.id.nil?
            create_user(user)
          else
            update_user(user)
          end
        end

        # ユーザーを削除
        def delete(id)
          user = ::User.find_by(id: id.value)
          return false unless user

          user.destroy
          true
        end

        private

        # UserからUserEntityに変換
        def to_entity(user)
          Domain::UserAggregate::Entity::UserEntity.new(
            id: Domain::UserAggregate::ValueObject::UserId.new(user.id),
            name: user.name,
            email: Domain::UserAggregate::ValueObject::Email.new(user.email),
            password_digest: user.encrypted_password,
            created_at: user.created_at,
            updated_at: user.updated_at
          )
        end

        # UserEntityからUserに変換
        def to_model(user_entity)
          ::User.new(
            id: user_entity.id&.value,
            name: user_entity.name,
            email: user_entity.email.value,
            encrypted_password: user_entity.password_digest
          )
        end

        # ユーザーを新規作成
        def create_user(user_entity)
          user = to_model(user_entity)
          user.save!
          to_entity(user)
        end

        # ユーザーを更新
        def update_user(user_entity)
          user = ::User.find(user_entity.id.value)
          user.update!(
            name: user_entity.name,
            email: user_entity.email.value,
            encrypted_password: user_entity.password_digest
          )
          to_entity(user)
        end
      end
    end
  end
end


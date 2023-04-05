class User < ApplicationRecord
  # パスワードを digest に変換する
  has_secure_password

  # 名前が空でないことを確認する検証する
  validates :name, presence: true
  # メールアドレスが空でなく, 値が一意であることを検証する
  validates :email, presence: true, uniqueness: true

  # User と Task の 1 対多の関係を定義
  has_many :tasks
end

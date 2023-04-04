class User < ApplicationRecord
  # パスワードを digest に変換する
  has_secure_password

  # 名前が空でないことを確認する検証する
  validates :name, presence: true
  # メールアドレスが空でなく, 値が一意であることを検証する
  validates :email, presence: true, uniqueness: true 
end

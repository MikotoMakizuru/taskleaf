class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  # タスクの name 属性の値にカンマは含まれていないか
  validate :validate_name_not_including_comma

  # User と Task の 1 対多の関係を定義
  belongs_to :user

  # カスタムのクエリー用のメソッド
  scope :recent, -> { order(created_at: :desc) }

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end

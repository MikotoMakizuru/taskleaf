class Task < ApplicationRecord
  # 名前がないタスクには, 「名前なし」を自動的に付与
  before_validation :set_nameless_name
  # name に 必須のデータはちゃんと入っているか, タスクの名前が 30 文字以内であるか.
  validates :name, presence: true, length: { maximum: 30 }
  # タスクの name 属性の値にカンマは含まれていないか
  validate :validate_name_not_including_comma

  private

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end

class Task < ApplicationRecord

  # 1 つのタスクに 1 つの画像を紐付けること, その画像を Task モデルから image と呼ぶこと
  has_one_attached :image

  # タスク名が空でなく, 30文字以下であるかとうか
  validates :name, presence: true, length: { maximum: 30 }
  # タスクの name 属性の値にカンマは含まれていないか
  validate :validate_name_not_including_comma

  # User と Task の 1 対多の関係を定義
  belongs_to :user

  # カスタムのクエリー用のメソッド
  scope :recent, -> { order(created_at: :desc) }

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end

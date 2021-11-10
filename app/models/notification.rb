class Notification < ApplicationRecord
  # 作成日時の降順に指定（新しい通知からデータを取得できる）
  default_scope -> { order(created_at: :desc) }
  # nillを許可するためにoptinalをつける
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :visitor, class_name: "User", optional: true
  belongs_to :visited, class_name: "User", optional: true
end

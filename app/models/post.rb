class Post < ApplicationRecord
  belongs_to :user

  validates :pet, presence: true
  validates :body, presence: true, length: {maximum: 200}
  validates :post_image, presence: true

  attachment :post_image
end

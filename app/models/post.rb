class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :pet, presence: true
  validates :body, presence: true, length: {maximum: 200}
  validates :post_image, presence: true

  attachment :post_image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end

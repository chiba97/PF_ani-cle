class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :pet, presence: true
  validates :body, presence: true, length: {maximum: 200}
  validates :post_image, presence: true

  attachment :post_image
  
  # 自分がお気に入りに登録しているか確認
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  # 投稿記事検索機能分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where(["pet LIKE? OR body LIKE?", "#{word}", "#{word}"])
    elsif search == "partial_match"
      @post = Post.where(["pet LIKE? OR body LIKE?", "%#{word}%", "%#{word}%"])
    else
      @post = Post.all
    end
  end
  
end

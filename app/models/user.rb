class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  # フォローする側のユーザーからみてフォローされる側のユーザーを集めるので、親はfollowing_id(フォローする側)を指定
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  # 中間テーブルを用いてフォローされた側のユーザーを集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower
  # フォローされる側のユーザーから見てフォローする側のユーザーを集めるので、親はfollower_id(フォローされる側)を指定
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  # 中間テーブルを用いてフォローする側のユーザーを集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following
  
  validates :name, presence: true, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :pet, length: {maximum: 20}
  validates :introduction, length: {maximum: 50}
  
  attachment :profile_image
  
  # 現時点で自分がフォローしようとしているユーザーを自分が既にフォローしているか判断する
  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
  
  # ユーザー検索機能分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
  
end

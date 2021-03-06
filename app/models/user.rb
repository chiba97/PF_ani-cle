class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :contacts, dependent: :destroy
  # favoritesテーブルを通していいねをした投稿記事を探す
  has_many :favorited_posts, through: :favorites, source: :post

  # ユーザーと通知モデルの紐付け
  # 自分からの通知
  has_many :active_notifications,
    class_name: "Notification",
    foreign_key: "visitor_id",
    dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications,
    class_name: "Notification",
    foreign_key: "visited_id",
    dependent: :destroy

  # フォローする側のユーザーからみてフォローされる側のユーザーを集めるので、親はfollowing_id(フォローする側)を指定
  has_many :active_relationships,
    class_name: "Relationship",
    foreign_key: :following_id
  # 中間テーブルを用いてフォローされた側のユーザーを集めることを「followings」と定義
  has_many :followings,
    through: :active_relationships,
    source: :follower
  # フォローされる側のユーザーから見てフォローする側のユーザーを集めるので、親はfollower_id(フォローされる側)を指定
  has_many :passive_relationships,
    class_name: "Relationship",
    foreign_key: :follower_id
  # 中間テーブルを用いてフォローする側のユーザーを集めることを「followers」と定義
  has_many :followers,
    through: :passive_relationships,
    source: :following

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :pet, length: { maximum: 20 }
  validates :introduction, length: { maximum: 50 }

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

  # フォロー通知の作成メソッド
  def create_notification_follow!(current_user)
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and action = ?",
      current_user.id,
      id,
      'follow',
    ])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # ゲストユーザーを探すor作成するメソッド
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト'
    end
  end
end

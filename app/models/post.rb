class Post < ApplicationRecord
  # PV数計測impressionist設定
  is_impressionable

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  # favoritesテーブルを通して、いいねしてくれたユーザーを
  has_many :favorited_users, through: :favorites, source: :user

  validates :pet, presence: true
  validates :body, presence: true, length: { maximum: 200 }
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

  # いいね通知の作成メソッド
  def create_notification_like!(current_user)
    # 既にいいねをされているのかを検索
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and post_id = ? and action = ?",
      current_user.id,
      user_id,
      id,
      'like'
    ])
    # いいねされていなかったら、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対していいねした場合は通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      # エラーがなければ情報を登録する
      notification.save if notification.valid?
    end
  end

  # コメント通知の作成メソッド
  def create_notification_comment!(current_user, comment_id)
    # 自分以外のコメントをしている人を全員取得して、全員に通知を送る
    temp_ids = Comment.select(
      :user_id
    ).where(
      post_id: id
    ).where.not(
      user_id: current_user.id
    ).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿主に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるので、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対してのコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end

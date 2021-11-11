class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  # チャット通知の作成メソッド
  def create_notification_dm!(current_user, message_id)
    # ルームに入っている自分以外のユーザーを取り出す
    temp_user=Entry.where(room_id: id).where.not(user_id: current_user.id)
    # 取り出したユーザーの入っているルームを検索する
    temp_room=temp_user.find_by(room_id: id)
    notification = current_user.active_notifications.new(
    room_id: id,
    message_id: message_id,
    visitor_id: current_user.id,
    visited_id: temp_room.user_id,
    action: 'dm'
    )
    # 自分が送ったチャットメッセージに対しては、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end

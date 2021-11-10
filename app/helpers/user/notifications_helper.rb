module User::NotificationsHelper
  
  # 未確認の通知を検索するためのメソッド
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
  
end

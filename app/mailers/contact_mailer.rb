class ContactMailer < ApplicationMailer
  default from: 'from@example.com'

  def send_when_admin_reply(user, contact)
    @user = user
    @title = contact.title
    @body = contact.body
    @answer = contact.reply
    mail to: user.email, subject: '【ANI-CLE】 お問い合わせありがとうございます'
  end
end

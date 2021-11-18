class Admin::ContactsController < ApplicationController
  def index
    @contacts = Contact.includes(:user).page(params[:page]).order(created_at: :desc).per(10)
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    contact = Contact.find(params[:id])
    contact.update(contact_params)
    user = contact.user
    ContactMailer.send_when_admin_reply(user, contact).deliver_now
    redirect_to admin_contacts_path, notice: "お問い合わせの返信が完了しました！"
  end

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy
    redirect_to admin_contacts_path, notice: "お問い合わせの削除が完了しました！"
  end

  private

  def contact_params
    params.require(:contact).permit(:reply)
  end
end

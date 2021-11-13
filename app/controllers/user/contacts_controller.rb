class User::ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    if @contact.save
      redirect_to user_path(@contact.user.id), notice: "お問い合わせ内容の送信が完了しました！"
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:title, :body)
  end
end

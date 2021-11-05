class Admin::UsersController < ApplicationController

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(6)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params_admin_user)
      redirect_to admin_user_path(@user.id), notice: "変更が完了しました！"
    else
      render "edit"
    end
  end

  private
  def params_admin_user
    params.require(:user).permit(:profile_image, :name, :email, :pet, :introduction, :is_deleted)
  end

end

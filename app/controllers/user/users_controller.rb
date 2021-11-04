class User::UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @posts = Post.page(params[:page]).reverse_order
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def unsubscribe
    @user = current_user
  end
  
  def withdraw
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :pet, :introduction, :profile_image)
  end
  
end

class User::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).reverse_order

    # 以下DMチャット機能ーStart
    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)

    unless @user.id == current_user.id
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id
            @is_room = true
            @room_id = cu.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
    # ーFinish
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "変更が完了しました！"
    else
      render :edit
    end
  end

  def unsubscribe
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    @user.posts.destroy_all
    reset_session
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    posts = Post.find(favorites)
    @favorite_posts = Kaminari.paginate_array(posts).page(params[:page]).per(8)
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.followings.page(params[:page]).per(8)
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(8)
  end

  private

  def user_params
    params.require(:user).permit(:name, :pet, :introduction, :profile_image)
  end
end

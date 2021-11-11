class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  # 投稿詳細にてPV数を計測したいのでshowを指定
  impressionist :actions => [:show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "投稿が完了しました！"
    else
      render :new
    end
  end

  def index
    @post_all = Post.all
    # いいねの多い順に並べる
    posts = Post.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(8)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
    impressionist(@post, nil, unique: [:session_hash.to_s])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "変更が完了しました！"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "削除が完了しました！"
  end

  private

  def post_params
    params.require(:post).permit(:post_image, :pet, :body)
  end
end

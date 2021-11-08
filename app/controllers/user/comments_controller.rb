class User::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comments = @post.comments.page(params[:page]).per(10)
    comment = current_user.comments.new(comment_params)
    comment.post_id = @post.id
    comment.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comments = @post.comments.page(params[:page]).per(10)
    Comment.find_by(id: params[:id]).destroy
  end

  private
  def comment_params
    params.require(:comment).permit(:comment)
  end

end

class User::SearchesController < ApplicationController
  
  def search
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      @users = @users.page(params[:page]).reverse_order.per(10)
      @word = params[:word]
    else
      @posts = Post.looks(params[:search], params[:word])
      @word = params[:word]
    end
  end
  
end

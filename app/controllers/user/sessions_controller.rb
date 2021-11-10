# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # ユーザーがログインをする前に退会しているか確認をする
  before_action :user_state, only: [:create]

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  protected

  # ユーザーが退会しているかを判断するメソッド、退会済みの場合は新規登録画面に飛ぶ
  def user_state
    @user = User.find_by(email: params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.is_deleted? == true)
        redirect_to new_user_registration_path
      end
    end
  end
end

class ApplicationController < ActionController::Base
  # 管理者ログアウト後は管理者ログインページの飛ぶ
  # ユーザーログアウト後はトップページに飛ぶ処理
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      root_path
    end
  end
end

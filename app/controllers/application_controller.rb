class ApplicationController < ActionController::Base

  rescue_from SecurityError do
      redirect_to root_path, notice: '管理者画面へのアクセス権限がありません！'
  end

  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。'
    end
  end

  protected

  def authenticate_admin_user!
    raise SecurityError unless current_user.try(:admin?)
  end

end

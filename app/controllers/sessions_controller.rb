class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    # フォームから送られてきたメールアドレスでユーザを検索検索する
    user = User.find_by(email: session_params[:email])

    # ユーザが見つかった場合は, authenticate メソッドで送られてきたパスワードの認証を行う
    if user&.authenticate(session_params[:password])
      # 認証に成功した場合に, セッションに user_id を格納する
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end

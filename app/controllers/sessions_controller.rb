class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])

    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy 
    reset_session
    redirect_to root_url, notice: "ログアウトしました。"
  end
  
end

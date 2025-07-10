class SessionsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_current_tenant

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      ActsAsTenant.current_tenant = user.organization
      redirect_to dashboard_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    ActsAsTenant.current_tenant = nil
    redirect_to login_path, notice: "Logged out!"
  end
end

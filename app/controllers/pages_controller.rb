class PagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_current_tenant

  def home
    if current_user
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end
end

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  set_current_tenant_through_filter
  before_action :set_current_tenant
  before_action :require_login
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def set_current_tenant
    if current_user
      ActsAsTenant.current_tenant = current_user.organization
    end
  end

  def require_login
    redirect_to login_path unless current_user
  end
end

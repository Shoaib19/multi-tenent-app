class ApplicationController < ActionController::Base
  include Pundit
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end
end

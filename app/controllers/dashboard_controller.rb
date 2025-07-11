class DashboardController < ApplicationController
  before_action :require_login

  def index
    @spaces = current_user.organization.spaces.includes(:creator, :required_age_group)
  end
end

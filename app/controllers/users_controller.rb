class UsersController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]
  skip_before_action :set_current_tenant

  def new
    @user = User.new
  end

  def create
    org = Organization.find_by(org_code: params[:user][:organization_id])

    unless org
      flash[:alert] = "Organization not found."
      return redirect_to signup_path
    end

    @user = User.new(user_params)
    @user.organization = org

    age = @user.age
    if age
      age_group = AgeGroup.where("min_age <= ? AND max_age >= ?", age, age).first
      @user.age_group = age_group
    end

    if @user.save
      if @user.requires_parental_consent?
        ParentalConsent.create!(user: @user, status: "pending", consent_type: "account")
      end

      @user.update(is_active: true) if @user.age_group.name == "Adult"
      session[:user_id] = @user.id
      ActsAsTenant.current_tenant = @user.organization
      redirect_to dashboard_path, notice: "Welcome!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :date_of_birth)
  end
end

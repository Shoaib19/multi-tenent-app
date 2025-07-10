class Admin::UsersController < Admin::BaseController
  def index
    @users = current_user.organization.users
  end

  def new
    @user = User.new
  end

  def create
    @user = current_user.organization.users.build(user_params)

    if @user.date_of_birth
      age = @user.age
      age_group = AgeGroup.where("min_age <= ? AND max_age >= ?", age, age).first
      @user.age_group = age_group
    end

    if @user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render :new, alert: "Failed to create user."
    end
  end

  def edit
    @user = current_user.organization.users.find(params[:id])
  end

  def update
    @user = current_user.organization.users.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User role updated."
    else
      render :edit, alert: "Update failed."
    end
  end

  def destroy
    @user = current_user.organization.users.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :date_of_birth)
  end
end


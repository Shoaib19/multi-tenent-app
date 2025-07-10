class Admin::SpacesController < Admin::BaseController
  before_action :set_space, only: [:edit, :update, :destroy]

  def index
    @spaces = Space.where(organization: current_user.organization)
  end

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(space_params)
    @space.organization = current_user.organization
    @space.created_by_user_id = current_user.id

    if @space.save
      redirect_to admin_spaces_path, notice: "Space created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @space.update(space_params)
      redirect_to admin_spaces_path, notice: "Space updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @space.destroy
    redirect_to admin_spaces_path, notice: "Space deleted."
  end

  private

  def set_space
    @space = Space.find_by!(id: params[:id], organization: current_user.organization)
  end

  def space_params
    params.require(:space ).permit(:name, :description, :required_age_group_id)
  end
end


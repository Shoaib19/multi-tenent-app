class SpacesController < ApplicationController
  before_action :require_login
  before_action :set_space, only: [ :show, :edit, :update, :destroy, :join ]
  before_action :authorize_space, only: [ :show, :edit, :update, :destroy, :join ]

  def index
    authorize Space
    @spaces = policy_scope(Space)
    # @spaces = current_user.organization.spaces
  end

  def show
  end

  def new
    authorize Space
    @space = current_user.organization.spaces.new
  end

  def create
    @space = current_user.organization.spaces.new(space_params)
    @space.creator = current_user
    authorize @space

    if @space.save
      flash[:notice] = "Space created successfully."
      redirect_to spaces_path
    else
      flash.now[:alert] = "Could not create space."
      render :new
    end
  end

  def edit
    unless @space.creator == current_user
      redirect_to spaces_path, alert: "You can't edit this space."
    end
  end

  def update
    unless @space.creator == current_user
      redirect_to spaces_path, alert: "You can't update this space."
      return
    end

    if @space.update(space_params)
      flash[:notice] = "Space updated successfully."
      redirect_to spaces_path
    else
      flash.now[:alert] = "Could not update space."
      render :edit
    end
  end

  def destroy
    unless @space.creator == current_user
      redirect_to spaces_path, alert: "You can't delete this space."
      return
    end

    @space.destroy
    flash[:notice] = "Space deleted successfully."
    redirect_to spaces_path
  end

  def join
    authorize @space, :join?

    if !current_user.is_active?
      flash[:alert] = "Your account is inactive. Please contact your admin."
      redirect_to spaces_path and return
    end

    if current_user.joined_spaces.include?(@space)
      flash[:notice] = "You have already joined this space."
      redirect_to spaces_path and return
    end

    if policy(@space).join?
      Membership.create!(user: current_user, space: @space)
      flash[:notice] = "You have joined the space."
    else
      if current_user.pending_space_consent_for?(@space)
        flash[:alert] = "Your parental consent request for this space is pending."
      else
        ParentalConsent.create!(
          user: current_user,
          space: @space,
          consent_type: :space_join,
          status: :pending
        )
        flash[:alert] = "Parental consent is required. We've recorded your request."
      end
    end
    redirect_to spaces_path
  end


  private

  def authorize_space
    authorize @space
  end

  def set_space
    @space = current_user.organization.spaces.find(params[:id])
  end

  def space_params
    params.require(:space).permit(:name, :description, :required_age_group_id)
  end
end

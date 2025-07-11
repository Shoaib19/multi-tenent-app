class SpacesController < ApplicationController
  before_action :require_login
  before_action :set_space, only: [ :show, :edit, :update, :destroy, :join ]
  before_action :authorize_space, only: [ :show, :edit, :update, :destroy ]

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
    @space = Space.find(params[:id])

    if !current_user.is_active?
      flash[:alert] = "Your account is inactive. Please contact your admin."
      redirect_to spaces_path and return
    end

    if current_user.joined_spaces.include?(@space)
      flash[:notice] = "You have already joined this space."
      redirect_to spaces_path and return
    end

    user_age_group = current_user.age_group
    required_age_group = @space.required_age_group

    if required_age_group.nil? || user_age_group.nil?
      Membership.create!(user: current_user, space: @space)
      flash[:notice] = "You joined the space successfully."
      redirect_to dashboard_path and return
    end

    case user_age_group.name
    when 'Adult'
      Membership.create!(user: current_user, space: @space)
      flash[:notice] = "You joined the space successfully."
      redirect_to dashboard_path and return
    when 'Teen'
      case required_age_group.name
      when 'Child', 'Teen'
        Membership.create!(user: current_user, space: @space)
        flash[:notice] = "You joined the space successfully."
        redirect_to dashboard_path and return
      when 'Adult'
        handle_space_consent_request
      else
        flash[:alert] = "You cannot join this space."
        redirect_to dashboard_path
      end
    when 'Child'
      case required_age_group.name
      when 'Child'
        Membership.create!(user: current_user, space: @space)
        flash[:notice] = "You joined the space successfully."
        redirect_to dashboard_path and return
      when 'Teen'
        handle_space_consent_request
      else
        flash[:alert] = "You cannot join this space."
        redirect_to dashboard_path
      end

    else
      flash[:alert] = "Invalid age group."
      redirect_to dashboard_path
    end
  end



  private

  def authorize_space
    authorize @space
  end

  def handle_space_consent_request
    consent = current_user.parental_consents.find_or_initialize_by(
      consent_type: :space_join,
      space: @space
    )
    if consent.new_record?
      consent.status = :pending
      consent.responded_at = nil
      consent.consent_type = :space_join
      consent.save!

      flash[:notice] = "Parental consent request submitted. Await approval."
    else
      flash[:alert] = "Your parental consent is #{consent.status}."
    end

    redirect_to dashboard_path
  end

  def set_space
    @space = current_user.organization.spaces.find(params[:id])
  end

  def space_params
    params.require(:space).permit(:name, :description, :required_age_group_id)
  end
end

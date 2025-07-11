class ParentalConsentsController < ApplicationController
  before_action :require_login

  def create_or_update
    consent_type = params[:consent_type].to_i
    space_id = params[:space_id]

    if consent_type == 1 && space_id.present?
      @consent = current_user.parental_consents
        .find_or_initialize_by(consent_type: :space_join, space_id: space_id)
    else
      @consent = current_user.parental_consents
        .find_or_initialize_by(consent_type: :account)
    end

    @consent.parent_email = params[:parent_email]
    @consent.status = params[:decision]
    @consent.responded_at = Time.current
    @consent.consent_type = consent_type

    if @consent.save
      if consent_type == 1 && params[:decision] == 'accepted'
        Membership.create!(user: current_user, space_id: space_id)
      end
      flash[:notice] = "Parental consent #{params[:decision]}"
    else
      flash[:alert] = "Could not save consent."
    end

    redirect_back fallback_location: root_path
  end
end

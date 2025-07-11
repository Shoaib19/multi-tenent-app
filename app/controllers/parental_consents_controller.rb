class ParentalConsentsController < ApplicationController
  before_action :require_login

  def create_or_update
    @consent = current_user.parental_consent || current_user.build_parental_consent

    @consent.parent_email = params[:parent_email]
    @consent.status = params[:decision]
    @consent.responded_at = Time.current
    @consent.consent_type = 0

    if @consent.save
      flash[:notice] = "Parental consent #{params[:decision]}"
    else
      flash[:alert] = "Could not save consent."
    end

    redirect_back fallback_location: root_path
  end
end

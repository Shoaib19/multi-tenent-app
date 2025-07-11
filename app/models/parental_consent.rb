class ParentalConsent < ApplicationRecord
  belongs_to :user
  belongs_to :space, optional: true

  enum :status, { pending: 0, accepted: 1, rejected: 2 }
  enum :consent_type, { account: 0, space_join: 1 }

  validates :status, presence: true
  validates :consent_type, presence: true

  after_save :update_user_activation

  private

  def update_user_activation
    return if pending?

    if accepted?
      user.update(is_active: true)
    elsif rejected? && account?
      user.update(is_active: false)
    end
  end
end

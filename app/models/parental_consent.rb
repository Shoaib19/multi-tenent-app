class ParentalConsent < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, accepted: 1, rejected: 2 }
  validates :status, presence: true
end

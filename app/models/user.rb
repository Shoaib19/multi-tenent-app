class User < ApplicationRecord
  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :age_group, optional: true

  has_secure_password

  has_many :spaces, foreign_key: :created_by_user_id, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :joined_spaces, through: :memberships, source: :space

  has_one :parental_consent, dependent: :destroy

  enum :role, {
    default_user: 0,
    moderator: 1,
    admin: 2
  }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password

  def parental_consent_accepted?
    parental_consent&.accepted?
  end

  def under_age?(threshold = 13)
    return false unless date_of_birth
    age < threshold
  end

  def age
    return nil unless date_of_birth
    now = Time.zone.now.to_date
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end
end

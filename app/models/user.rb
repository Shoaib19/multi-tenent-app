class User < ApplicationRecord
  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :age_group, optional: true

  has_secure_password

  has_many :spaces, foreign_key: :created_by_user_id, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :joined_spaces, through: :memberships, source: :space

  has_many :parental_consents, dependent: :destroy

  enum :role, {
    default_user: 0,
    moderator: 1,
    admin: 2
  }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password
  validate :single_admin_per_organization, if: -> { admin? }

  def single_admin_per_organization
    if organization.users.where(role: "admin").where.not(id: id).exists?
      errors.add(:role, "There can be only one admin per organization")
    end
  end

  def accepted_account_consent?
    parental_consents.where(consent_type: 0, status: :accepted).exists?
  end

  def pending_account_consent?
    parental_consents.where(consent_type: 0, status: :pending).exists?
  end

  def rejected_account_consent?
    parental_consents.where(consent_type: 0, status: :rejected).exists?
  end

  def accepted_space_consent_for?(space)
    parental_consents.where(consent_type: 1, space_id: space.id, status: :accepted).exists?
  end

  def pending_space_consent_for?(space)
    parental_consents.where(consent_type: 1, space_id: space.id, status: :pending).exists?
  end

  def rejected_space_consent_for?(space)
    parental_consents.where(consent_type: 1, space_id: space.id, status: :rejected).exists?
  end

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

  def requires_parental_consent?
    return false if admin?
    return false if age_group.nil? || age_group.name.downcase == "adult"
    true
  end

  def needs_parental_consent_popup?
    requires_parental_consent? && pending_account_consent?
  end
end

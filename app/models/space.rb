class Space < ApplicationRecord
  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :required_age_group, class_name: 'AgeGroup'
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_user_id'

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  validates :name, presence: true
end

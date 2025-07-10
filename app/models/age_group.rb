class AgeGroup < ApplicationRecord
  has_many :users
  has_many :spaces, foreign_key: :required_age_group_id

  validates :name, :min_age, :max_age, presence: true
  validates :min_age, numericality: { greater_than_or_equal_to: 0 }
  validates :max_age, numericality: { greater_than_or_equal_to: :min_age }
end

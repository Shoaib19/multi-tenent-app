class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :spaces, dependent: :destroy

  enum :org_code, {
    org_1: 0,
    org_2: 1,
  }
end

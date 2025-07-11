class RemoveParentalConsentStatusFromUser < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :parental_consent_status, :string
  end
end

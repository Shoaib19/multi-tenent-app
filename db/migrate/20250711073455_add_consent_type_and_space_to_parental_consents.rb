class AddConsentTypeAndSpaceToParentalConsents < ActiveRecord::Migration[8.0]
  def change
    add_column :parental_consents, :consent_type, :string
    add_reference :parental_consents, :space, foreign_key: true, type: :uuid
  end
end

class AddParentEmailInParentConsent < ActiveRecord::Migration[8.0]
  def change
    add_column :parental_consents, :parent_email, :string
  end
end

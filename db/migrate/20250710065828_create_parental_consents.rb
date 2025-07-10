class CreateParentalConsents < ActiveRecord::Migration[8.0]
  def change
    create_table :parental_consents, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 'pending'
      t.datetime :responded_at
      t.timestamps
    end
  end
end

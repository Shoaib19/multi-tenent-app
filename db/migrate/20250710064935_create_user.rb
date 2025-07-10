class CreateUser < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.date :date_of_birth
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :age_group, foreign_key: true, type: :uuid
      t.integer :role, default: 0,  null: false
      t.string :parental_consent_status, default: 'pending'
      t.string :password_digest
      t.boolean :is_active, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end

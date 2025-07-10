class CreateSpaces < ActiveRecord::Migration[8.0]
  def change
    create_table :spaces, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :required_age_group, null: false, foreign_key: { to_table: :age_groups }, type: :uuid
      t.references :created_by_user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.timestamps
    end
  end
end

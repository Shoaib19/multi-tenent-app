class CreateOrganization < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.integer :org_code, null: false
      t.string :name, null: false
      t.text :description
      t.jsonb :settings_json, default: {}
      t.timestamps
    end
  end
end

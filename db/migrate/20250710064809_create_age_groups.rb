class CreateAgeGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :age_groups, id: :uuid do |t|
      t.string :name, null: false
      t.integer :min_age, null: false
      t.integer :max_age, null: false
      t.timestamps
    end
  end
end

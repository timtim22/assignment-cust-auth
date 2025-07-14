class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.integer :min_age, default: 0
      t.integer :max_age, default: 120

      t.timestamps
    end
    
    add_index :organizations, :name
  end
end

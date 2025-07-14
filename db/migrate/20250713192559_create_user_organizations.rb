class CreateUserOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_organizations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :role, default: 'member'

      t.timestamps
    end
    
    add_index :user_organizations, [:user_id, :organization_id], unique: true
  end
end

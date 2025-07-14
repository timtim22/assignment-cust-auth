class AddAgeGroupToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :age_group, :string, default: 'adult'
    add_index :users, :age_group
  end
end

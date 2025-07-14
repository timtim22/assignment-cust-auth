class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :age_rating, default: 'adult'
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :contents, :age_rating
    add_index :contents, [:organization_id, :age_rating]
    add_index :contents, :created_at
  end
end

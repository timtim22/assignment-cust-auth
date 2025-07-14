class CreateOrganizationAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_analytics do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :metric_name
      t.decimal :metric_value
      t.datetime :recorded_at

      t.timestamps
    end
  end
end

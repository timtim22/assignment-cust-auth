class AddParentalConsentToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :parental_consent, :boolean, default: true
  end
end

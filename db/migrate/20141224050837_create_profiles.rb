class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.integer :gender, null: false, default: 0
      t.date :date_of_birth
      t.string :country

      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end

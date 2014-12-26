class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.references :store, index: true
      t.text :description
      t.money :price
      t.text :source

      t.timestamps null: false
    end
    add_foreign_key :products, :stores
  end
end

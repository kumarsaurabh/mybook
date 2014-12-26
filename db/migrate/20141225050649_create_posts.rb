class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :guid
      t.string :message
      t.references :product, index: true
      t.references :author, index: true

      t.timestamps null: false
    end
    add_foreign_key :posts, :products
    add_foreign_key :posts, :users, column: :author_id
  end
end

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :team_id
      t.integer :category_id
      t.string :title
      t.text :post
      t.string :image_id
      t.integer :status
      t.timestamps
    end
  end
end

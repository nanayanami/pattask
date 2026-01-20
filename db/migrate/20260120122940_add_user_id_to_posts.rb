class AddUserIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :user_id, :integer unless column_exists?(:posts, :user_id)
  end
end

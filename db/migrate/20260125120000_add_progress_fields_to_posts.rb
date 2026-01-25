class AddProgressFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :progress_status, :integer, default: 1, null: false
    add_column :posts, :completed, :boolean, default: false, null: false
  end
end

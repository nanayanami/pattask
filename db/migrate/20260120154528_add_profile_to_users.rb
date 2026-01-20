class AddProfileToUsers < ActiveRecord::Migration[7.1]
  def change
    return if column_exists?(:users, :profile)

    add_column :users, :profile, :string
  end
end

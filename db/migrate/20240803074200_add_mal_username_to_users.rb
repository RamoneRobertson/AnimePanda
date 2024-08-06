class AddMalUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :mal_username, :string
  end
end

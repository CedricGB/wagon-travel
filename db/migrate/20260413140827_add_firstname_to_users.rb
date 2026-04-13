class AddFirstnameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :firstname, :string
  end
end

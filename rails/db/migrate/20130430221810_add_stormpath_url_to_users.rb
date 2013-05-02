class AddStormpathUrlToUsers < ActiveRecord::Migration
  def up
    add_column :users, :stormpath_url, :string
    add_index :users, :stormpath_url
  end

  def down
    remove_column :users, :stormpath_url
  end
end
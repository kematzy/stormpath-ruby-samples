class AddCssBackgroundToUsers < ActiveRecord::Migration
  def change
    add_column :users, :css_background, :string
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :stormpath_url
    end
  end
end

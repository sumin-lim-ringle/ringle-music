class ChangeColumnsFromOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :usable, :integer
    add_column :groups, :usable, :integer
    add_column :likes, :likable, :integer
    add_column :user_playlists, :usable, :integer
    add_column :group_playlists, :usable, :integer
    add_column :user_groups, :usable, :integer
  end
end

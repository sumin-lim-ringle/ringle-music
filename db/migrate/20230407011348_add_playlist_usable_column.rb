class AddPlaylistUsableColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :usable, :integer, :default => 1
  end
end

class CreateMusicPlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :music_playlists do |t|
      t.references :music, foreign_key: true
      t.references :playlist, foreign_key: true
      t.belongs_to :user
      t.timestamps
    end
  end
end

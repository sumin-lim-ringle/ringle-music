class CreateUserPlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :user_playlists do |t|
      t.references :user, foreign_key: true
      t.references :music, foreign_key: true
      t.integer :usable
      
      t.timestamps
    end
  end
end

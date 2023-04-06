class Playlist < ApplicationRecord
    has_many :music_playlists, dependent: :destroy
    has_many :musics, through: :music_playlists
    
    belongs_to :ownable, polymorphic: true
end

class MusicPlaylist < ApplicationRecord
    belongs_to :music
    belongs_to :playlist
    belongs_to :user
end

class GroupPlaylist < ApplicationRecord
  belongs_to :music
  belongs_to :user
  belongs_to :group
end

class Music < ApplicationRecord
  has_many :likes
  has_many :user_playlists
  has_many :group_playlists
end

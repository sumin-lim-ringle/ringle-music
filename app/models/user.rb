class User < ApplicationRecord
  has_many :user_playlists
  has_many :likes
  has_many :group_playlists
  has_many :user_groups
end

class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :playlist, as: :ownable, dependent: :destroy
  has_many :music_playlists
  
  has_many :likes, dependent: :destroy
  
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
end

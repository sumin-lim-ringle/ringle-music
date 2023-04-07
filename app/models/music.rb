require 'elasticsearch/model'

class Music < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do
    mappings dynamic: false do
      indexes :music_name, type: :text
      indexes :artist_name, type: :text
      indexes :album_name, type: :text
      indexes :likes_count, type: :integer
    end
  end

  has_many :music_playlists, dependent: :destroy

  has_many :playlists, through: :music_playlists
  has_many :likes, dependent: :destroy

  # search & sort 
  def self.search_word_sort(query, sortby)
    @sort_param = {"#{sortby}" => { order: 'desc' }}

    self.search({
      "track_scores": true, # indicate score
      query: {
        bool: {
          must: [
          {
            multi_match: {
              query: query,
              fields: [:music_name, :artist_name, :album_name]
            }, 
          },
          ], 
          
        }
      }, sort: [
        @sort_param
      ]
    })
  end
end

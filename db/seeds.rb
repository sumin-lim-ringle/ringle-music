# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "csv"
require "faker"

# making users
user_cnt = 50
User.all.map(&:destroy)

1.upto(user_cnt) do |i|
  User.create(
    password: "thisisthepasswordof#{i}",
    email: "test#{i}@example.com",
    usable: 1
  )
end

# making musics
music_cnt = 1000
Music.all.map(&:destroy)
file_path = Rails.root.join("config", "musics", "music.csv")
music_file = CSV.parse(File.read(file_path), headers: true)

1.upto(music_cnt) do |i|
  Music.create(
    music_name: music_file[i]["title"],
    artist_name: music_file[i]["artist_name"],
    album_name: music_file[i]["album_name"],
    likes_count: rand(234..10_000)
  )
end

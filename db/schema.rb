# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_29_165827) do
  create_table "group_playlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "music_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_playlists_on_group_id"
    t.index ["music_id"], name: "index_group_playlists_on_music_id"
    t.index ["user_id"], name: "index_group_playlists_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "music_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["music_id"], name: "index_likes_on_music_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "musics", force: :cascade do |t|
    t.string "music_name"
    t.string "artist_name"
    t.string "album_name"
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "user_playlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "music_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["music_id"], name: "index_user_playlists_on_music_id"
    t.index ["user_id"], name: "index_user_playlists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "group_playlists", "groups"
  add_foreign_key "group_playlists", "musics"
  add_foreign_key "group_playlists", "users"
  add_foreign_key "likes", "musics"
  add_foreign_key "likes", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_playlists", "musics"
  add_foreign_key "user_playlists", "users"
end

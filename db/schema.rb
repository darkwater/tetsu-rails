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

ActiveRecord::Schema[7.0].define(version: 2022_10_09_124834) do
  create_table "anidb_animes", force: :cascade do |t|
    t.integer "dateflags"
    t.string "year"
    t.string "atype"
    t.string "romaji_name"
    t.string "kanji_name"
    t.string "english_name"
    t.string "short_name_list"
    t.integer "episodes"
    t.integer "special_ep_count"
    t.date "air_date"
    t.date "end_date"
    t.string "picname"
    t.boolean "nsfw"
    t.integer "specials_count"
    t.integer "credits_count"
    t.integer "other_count"
    t.integer "trailer_count"
    t.integer "parody_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "anidb_episodes", force: :cascade do |t|
    t.integer "anime_id"
    t.integer "length"
    t.integer "rating"
    t.integer "votes"
    t.string "epno"
    t.string "english_name"
    t.string "romaji_name"
    t.string "kanji_name"
    t.datetime "aired"
    t.integer "etype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "anidb_files", force: :cascade do |t|
    t.integer "anime_id"
    t.integer "episode_id"
    t.integer "group_id"
    t.integer "state"
    t.integer "size"
    t.string "ed2k"
    t.string "colour_depth"
    t.string "quality"
    t.string "source"
    t.string "audio_codec_list"
    t.integer "audio_bitrate_list"
    t.string "video_codec"
    t.integer "video_bitrate"
    t.string "video_resolution"
    t.string "dub_language"
    t.string "sub_language"
    t.integer "length_in_seconds"
    t.string "description"
    t.datetime "aired_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["size", "ed2k"], name: "index_anidb_files_on_size_and_ed2k", unique: true
  end

  create_table "anidb_groups", force: :cascade do |t|
    t.integer "rating"
    t.integer "votes"
    t.integer "acount"
    t.integer "fcount"
    t.string "name"
    t.string "short"
    t.string "irc_channel"
    t.string "irc_server"
    t.string "url"
    t.string "picname"
    t.integer "founded_date"
    t.integer "disbanded_date"
    t.integer "date_flags"
    t.integer "last_release_date"
    t.integer "last_activity_date"
    t.string "group_relations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "indexed_files", force: :cascade do |t|
    t.string "path"
    t.string "filename"
    t.string "ed2k"
    t.integer "filesize"
    t.integer "file_id"
    t.string "file_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_id", "file_type"], name: "index_indexed_files_on_file_id_and_file_type"
    t.index ["path"], name: "index_indexed_files_on_path", unique: true
  end

end

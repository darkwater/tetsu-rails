class CreateAnidbAnimes < ActiveRecord::Migration[7.0]
  def change
    create_table :anidb_animes do |t|
      t.integer :dateflags
      t.string :year
      t.string :atype
      t.string :romaji_name
      t.string :kanji_name
      t.string :english_name
      t.string :short_name_list
      t.integer :episode_count
      t.integer :special_ep_count
      t.datetime :air_date
      t.datetime :end_date
      t.string :picname
      t.boolean :nsfw
      t.integer :specials_count
      t.integer :credits_count
      t.integer :other_count
      t.integer :trailer_count
      t.integer :parody_count

      t.timestamps
    end

    create_table :anidb_episodes do |t|
      t.integer :anime_id
      t.integer :length
      t.integer :rating
      t.integer :votes
      t.string :epno
      t.string :english_name
      t.string :romaji_name
      t.string :kanji_name
      t.datetime :aired
      t.integer :etype

      t.timestamps
    end

    create_table :anidb_groups do |t|
      t.integer :rating
      t.integer :votes
      t.integer :acount
      t.integer :fcount
      t.string :name
      t.string :short
      t.string :irc_channel
      t.string :irc_server
      t.string :url
      t.string :picname
      t.datetime :founded_date
      t.datetime :disbanded_date
      t.integer :date_flags
      t.datetime :last_release_date
      t.datetime :last_activity_date
      t.string :group_relations

      t.timestamps
    end

    create_table :anidb_files do |t|
      t.integer :anime_id
      t.integer :episode_id
      t.integer :group_id
      t.integer :state
      t.integer :size
      t.string :ed2k
      t.string :colour_depth
      t.string :quality
      t.string :source
      t.string :audio_codec_list
      t.integer :audio_bitrate_list
      t.string :video_codec
      t.integer :video_bitrate
      t.string :video_resolution
      t.string :dub_language
      t.string :sub_language
      t.integer :length_in_seconds
      t.string :description
      t.datetime :aired_date

      t.timestamps
    end

    add_index :anidb_files, [ :size, :ed2k ], unique: true

    create_table :indexed_files do |t|
      t.string :path
      t.string :filename
      t.string :ed2k
      t.integer :filesize
      t.integer :file_id
      t.string :file_type

      t.timestamps
    end

    add_index :indexed_files, :path, unique: true
    add_index :indexed_files, [ :file_id, :file_type ]
  end
end

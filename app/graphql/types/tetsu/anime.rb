module Types::Tetsu
  class Anime < Types::Base::Object
    field :id, ID, null: false
    field :year, String, null: false
    field :atype, String, null: false
    field :romaji_name, String, null: false
    field :english_name, String, null: false
    field :other_name, String, null: false
    field :short_name_list, [String], null: false
    field :episode_count, Integer, null: false
    field :special_ep_count, Integer, null: false
    field :air_date, GraphQL::Types::ISO8601Date, null: false
    field :end_date, GraphQL::Types::ISO8601Date, null: false
    field :picname, String, null: false
    field :nsfw, Boolean, null: false
    field :specials_count, Integer, null: false
    field :credits_count, Integer, null: false
    field :other_count, Integer, null: false
    field :trailer_count, Integer, null: false
    field :parody_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :episodes, Types::Tetsu::Episode.connection_type, null: false
    field :files, Types::Tetsu::File.connection_type, null: false
    # field :related_anime, Types::Tetsu::Anime.related_connection_type, null: false
    # field :characters, Types::Tetsu::Character.anime_connection_type, null: false
  end
end

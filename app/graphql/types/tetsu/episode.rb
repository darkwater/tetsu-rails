module Types::Tetsu
  class Episode < Types::Base::Object
    field :id, ID, null: false
    field :length, Integer, null: false, description: "Length of the episode in minutes"
    field :rating, Integer, null: false
    field :votes, Integer, null: false
    field :epno, String, null: false
    field :english_name, String, null: false
    field :romaji_name, String, null: false
    field :kanji_name, String, null: false
    field :aired, GraphQL::Types::ISO8601Date, null: false
    field :etype, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :anime, Types::Tetsu::Anime, null: false, method: :anime_or_fetch
    field :files, Types::Tetsu::File.connection_type, null: false
    field :indexed_files, Types::Tetsu::IndexedFile.connection_type, null: false
  end
end

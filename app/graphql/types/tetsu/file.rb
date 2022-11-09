module Types::Tetsu
  class File < Types::Base::Object
    field :id, ID, null: false
    field :state, Integer, null: false
    field :size, Integer, null: false
    field :colour_depth, String, null: false
    field :quality, String, null: false
    field :source, String, null: false
    # audio tracks
    # video tracks
    # languages
    field :length, Integer, null: false, description: "Length of the file in seconds"
    field :description, String, null: false
    field :aired_date, GraphQL::Types::ISO8601Date, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :anime, Types::Tetsu::Anime, null: false, method: :anime_or_fetch
    field :episode, Types::Tetsu::Episode, null: false, method: :episode_or_fetch
    field :group, Types::Tetsu::Group, null: false, method: :group_or_fetch
    field :indexed_files, Types::Tetsu::IndexedFile.connection_type, null: false
  end
end

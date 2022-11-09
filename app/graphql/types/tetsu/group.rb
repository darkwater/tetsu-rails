module Types::Tetsu
  class Group < Types::Base::Object
    field :id, ID, null: false
    field :rating, Integer, null: false
    field :votes, Integer, null: false
    field :anime_count, Integer, null: false, method: :acount
    field :file_count, Integer, null: false, method: :fcount
    field :name, String, null: false
    field :short_name, String, null: false, method: :short
    field :irc_channel, String, null: false
    field :irc_server, String, null: false
    field :url, String, null: false
    field :picname, String, null: false
    field :founded_date, GraphQL::Types::ISO8601Date, null: false
    field :disbanded_date, GraphQL::Types::ISO8601Date, null: true
    field :date_flags, Integer, null: false
    field :last_release_date, GraphQL::Types::ISO8601DateTime, null: false
    field :last_activity_date, GraphQL::Types::ISO8601DateTime, null: false
    # group relations
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :files, Types::Tetsu::File.connection_type, null: false
  end
end

module Types::Tetsu
  class IndexedFile < Types::Base::Object
    field :id, ID, null: false
    field :path, String, null: false
    field :filename, String, null: false
    field :filesize, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :file, Types::Tetsu::File, null: true #, method: :file_or_fetch
  end
end

module Types
  class QueryType < Types::Base::Object
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :anime, Types::Tetsu::Anime.connection_type, null: false
    def anime
      Anidb::Anime.order(air_date: :desc)
    end

    field :episodes, Types::Tetsu::Episode.connection_type, null: false do
      argument :aid, ID, required: true
    end
    def episodes(aid:)
      Anidb::Episode.where(aid: aid).order(epno: :asc)
    end
  end
end

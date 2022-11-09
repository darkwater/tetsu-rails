require "anidb/anidb"

class Anidb::ExploreAnimeJob < ApplicationJob
  queue_as :default

  def perform(anime)
    if anime.episodes.count != anime.episode_count
      1.upto(anime.episode_count) do |ep|
        next if anime.episodes.where(epno: ep).exists? # TODO: breaks for eg. "02" because int
        Anidb::Anidb.instance.episode(aid: anime.id, epno: ep)&.save!
      end
    end
  end
end

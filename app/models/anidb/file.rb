require "anidb/anidb"

class Anidb::File < ApplicationRecord
  belongs_to :anime, optional: true
  belongs_to :episode, optional: true
  belongs_to :group, optional: true
  has_many :indexed_files, as: :file

  def self.find_or_fetch_by_ed2k(size:, ed2k:)
    if file = Anidb::File.find_by(ed2k: ed2k, size: size)
      return file
    end

    file = Anidb::Anidb.instance.file_by_ed2k(size: size, ed2k: ed2k)
    file&.save!

    file
  end

  def anime_or_fetch
    if anime.nil?
      self.anime = Anidb::Anidb.instance.anime(aid: anime_id)
      self.anime.save!
    end

    self.anime
  end

  def episode_or_fetch
    if episode.nil?
      self.episode = Anidb::Anidb.instance.episode(eid: episode_id)
      self.episode.save!
    end

    self.episode
  end

  def group_or_fetch
    if group.nil?
      self.group = Anidb::Anidb.instance.group(gid: group_id)
      self.group.save!
    end

    self.group
  end
end

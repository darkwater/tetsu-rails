require "anidb/anidb"

class Anidb::File < ApplicationRecord
  belongs_to :anime, optional: true
  belongs_to :episode, optional: true
  belongs_to :group, optional: true
  has_many :indexed_files, as: :file

  def self.fetch_by_ed2k(size:, hash:)
    Anidb::Anidb.instance.file_by_ed2k(size: size, hash: hash)
  end
end

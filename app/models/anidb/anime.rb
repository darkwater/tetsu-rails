class Anidb::Anime < ApplicationRecord
  has_many :episodes
  has_many :files
end

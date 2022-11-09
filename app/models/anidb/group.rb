class Anidb::Group < ApplicationRecord
  has_many :files
  has_many :indexed_files, through: :files
  has_many :episodes, -> { distinct }, through: :files
  has_many :anime, -> { distinct }, through: :files
end

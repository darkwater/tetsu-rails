class Anidb::Episode < ApplicationRecord
  belongs_to :anime, optional: true
  has_many :files
  has_many :indexed_files, through: :files
end

class Anidb::Episode < ApplicationRecord
  belongs_to :anime, optional: true
  has_many :files
end

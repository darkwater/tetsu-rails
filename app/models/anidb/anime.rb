class Anidb::Anime < ApplicationRecord
  has_many :episodes
  has_many :files
  has_many :related_anime, class_name: "Anidb::RelatedAnime", foreign_key: :from_id
  has_many :related_characters, class_name: "Anidb::RelatedCharacter", foreign_key: :anime_id
  has_many :characters, through: :related_characters
end

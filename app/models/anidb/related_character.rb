class Anidb::RelatedCharacter < ApplicationRecord
  belongs_to :anime, class_name: "Anidb::Anime", foreign_key: :anime_id, optional: true
  belongs_to :character, class_name: "Anidb::Character", foreign_key: :character_id, optional: true
end

class Anidb::RelatedAnime < ApplicationRecord
  belongs_to :from, class_name: "Anidb::Anime", foreign_key: :from_id, optional: true
  belongs_to :to, class_name: "Anidb::Anime", foreign_key: :to_id, optional: true
end

class CreateAnidbRelatedCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :anidb_related_characters do |t|
      t.integer :anime_id, null: false
      t.integer :character_id, null: false
      t.integer :creator_id
      t.string :appearance
      t.string :ctype
      t.string :gender

      t.timestamps
    end
  end
end

class CreateAnidbRelatedAnimes < ActiveRecord::Migration[7.0]
  def change
    create_table :anidb_related_animes do |t|
      t.integer :from_id, null: false
      t.integer :to_id, null: false
      t.string :rtype, null: false

      t.timestamps
    end
  end
end

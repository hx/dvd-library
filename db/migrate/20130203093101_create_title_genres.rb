class CreateTitleGenres < ActiveRecord::Migration
  def change
    create_table :title_genres do |t|
      t.integer :title_id
      t.integer :genre_id

      t.timestamps
    end
  end
end

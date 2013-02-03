class CreateTitleMediaTypes < ActiveRecord::Migration
  def change
    create_table :title_media_types do |t|
      t.integer :title_id
      t.integer :media_type_id

      t.timestamps
    end
  end
end

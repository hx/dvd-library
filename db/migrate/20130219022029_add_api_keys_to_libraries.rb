class AddApiKeysToLibraries < ActiveRecord::Migration
  def change
    change_table :libraries do |t|
      t.column :tmdb_api_key, :string
      t.column :tvdb_api_key, :string
    end
  end
end

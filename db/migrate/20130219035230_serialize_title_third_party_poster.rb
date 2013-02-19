class SerializeTitleThirdPartyPoster < ActiveRecord::Migration
  def change
    rename_column :titles, :third_party_poster_url, :third_party_poster
  end
end

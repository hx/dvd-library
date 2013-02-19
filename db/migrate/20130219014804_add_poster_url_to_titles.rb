class AddPosterUrlToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :third_party_poster_url, :string
  end
end

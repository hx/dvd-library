class AddLibraryIdToTitles < ActiveRecord::Migration
  def change
    change_table :titles do |t|
      t.column :library_id, :integer
    end
  end
end

class AddCertifiationIndexToTitles < ActiveRecord::Migration
  def change
    add_index :titles, :certification
  end
end

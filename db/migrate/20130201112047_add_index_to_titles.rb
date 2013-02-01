class AddIndexToTitles < ActiveRecord::Migration
  def change
    change_table :titles do |t|
      t.index :barcode
    end
  end
end

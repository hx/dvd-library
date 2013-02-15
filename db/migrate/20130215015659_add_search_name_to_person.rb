class AddSearchNameToPerson < ActiveRecord::Migration
  def change
    change_table :people do |t|
      t.column :search_name, :string
      t.index :search_name
    end
  end
end

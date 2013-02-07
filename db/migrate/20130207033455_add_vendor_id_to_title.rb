class AddVendorIdToTitle < ActiveRecord::Migration
  def change
    add_column :titles, :vendor_id, :string
    add_index :titles, [:vendor_id]
  end
end

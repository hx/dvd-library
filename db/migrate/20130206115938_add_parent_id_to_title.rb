class AddParentIdToTitle < ActiveRecord::Migration
  def change

    change_table :titles do |t|
      t.column :parent_id, :integer
    end

    create_table(:title_hierarchies, id: false) do |t|
      t.integer  :ancestor_id,    null: false
      t.integer  :descendant_id,  null: false
      t.integer  :generations,    null: false
    end

    # For "all progeny of…" selects:
    add_index :title_hierarchies, [:ancestor_id, :descendant_id], unique: true

    # For "all ancestors of…" selects
    add_index :title_hierarchies, [:descendant_id]
  end
end

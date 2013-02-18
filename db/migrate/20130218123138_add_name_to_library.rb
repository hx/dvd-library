class AddNameToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :name, :string, default: ''
  end
end

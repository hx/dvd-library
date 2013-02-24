class RemoveLibraryDefaultName < ActiveRecord::Migration
  def up
    change_column_default :libraries, :name, nil
  end

  def down
    change_column_default :libraries, :name, ''
  end
end

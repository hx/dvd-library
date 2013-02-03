class CreateStudioInvolvements < ActiveRecord::Migration
  def change
    create_table :studio_involvements do |t|
      t.integer :studio_id
      t.integer :title_id

      t.timestamps
    end
  end
end

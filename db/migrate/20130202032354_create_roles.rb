class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :title_id
      t.integer :person_id
      t.string :name
      t.string :credit_type
      t.string :credited_as
      t.boolean :uncredited
      t.boolean :voice

      t.timestamps
    end
  end
end

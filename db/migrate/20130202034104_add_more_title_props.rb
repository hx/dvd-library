class AddMoreTitleProps < ActiveRecord::Migration
  def change
    change_table :titles do |t|
      t.text :overview
      t.string :sort_title
      t.integer :production_year
      t.date :release_date
      t.integer :runtime
      t.string :certification
    end
  end
end

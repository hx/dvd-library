class VariousIndexes < ActiveRecord::Migration
  def change
    add_index :people, [:first_name, :middle_name, :last_name, :birth_year], unique: true, name: 'index_people_on_everything'
    add_index :genres, :name, unique: true
    add_index :roles, [:title_id, :person_id, :name, :department, :credited_as, :uncredited, :voice], unique: true, name: 'index_roles_on_everything'
    add_index :studios, :name, unique: true
    add_index :media_types, :name, unique: true
    add_index :studio_involvements, [:studio_id, :title_id], unique: true
    add_index :title_media_types, [:media_type_id, :title_id], unique: true
    add_index :title_genres, [:genre_id, :title_id], unique: true
  end
end

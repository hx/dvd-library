# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130204032911) do

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "genres", ["name"], :name => "index_genres_on_name", :unique => true

  create_table "libraries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "media_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "media_types", ["name"], :name => "index_media_types_on_name", :unique => true

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "birth_year"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "people", ["first_name", "middle_name", "last_name", "birth_year"], :name => "index_people_on_everything", :unique => true

  create_table "roles", :force => true do |t|
    t.integer  "title_id"
    t.integer  "person_id"
    t.string   "name"
    t.string   "department"
    t.string   "credited_as"
    t.boolean  "uncredited"
    t.boolean  "voice"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "roles", ["title_id", "person_id", "name", "department", "credited_as", "uncredited", "voice"], :name => "index_roles_on_everything", :unique => true

  create_table "studio_involvements", :force => true do |t|
    t.integer  "studio_id"
    t.integer  "title_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "studio_involvements", ["studio_id", "title_id"], :name => "index_studio_involvements_on_studio_id_and_title_id", :unique => true

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "studios", ["name"], :name => "index_studios_on_name", :unique => true

  create_table "title_genres", :force => true do |t|
    t.integer  "title_id"
    t.integer  "genre_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "title_genres", ["genre_id", "title_id"], :name => "index_title_genres_on_genre_id_and_title_id", :unique => true

  create_table "title_media_types", :force => true do |t|
    t.integer  "title_id"
    t.integer  "media_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "title_media_types", ["media_type_id", "title_id"], :name => "index_title_media_types_on_media_type_id_and_title_id", :unique => true

  create_table "titles", :force => true do |t|
    t.string   "barcode"
    t.string   "title"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "overview"
    t.string   "sort_title"
    t.integer  "production_year"
    t.date     "release_date"
    t.integer  "runtime"
    t.string   "certification"
    t.integer  "library_id"
  end

  add_index "titles", ["barcode"], :name => "index_titles_on_barcode"

end

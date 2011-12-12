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

ActiveRecord::Schema.define(:version => 20111206230618) do

  create_table "rubygems", :force => true do |t|
    t.string   "name",                      :null => false
    t.integer  "downloads",  :default => 0, :null => false
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.string   "full_name",                            :null => false
    t.text     "authors",                              :null => false
    t.string   "number",                               :null => false
    t.string   "platform",                             :null => false
    t.string   "rubyforge_project"
    t.text     "summary"
    t.text     "description"
    t.boolean  "prerelease",        :default => false, :null => false
    t.boolean  "indexed",           :default => false, :null => false
    t.boolean  "latest",            :default => false, :null => false
    t.integer  "rubygem_id",                           :null => false
    t.integer  "position"
    t.datetime "built_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["full_name"], :name => "index_versions_on_full_name"
  add_index "versions", ["latest"], :name => "index_versions_on_latest"
  add_index "versions", ["number", "platform", "rubygem_id"], :name => "index_versions_on_number_and_platform_and_rubygem_id", :unique => true
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["platform"], :name => "index_versions_on_platform"
  add_index "versions", ["prerelease"], :name => "index_versions_on_prerelease"

end

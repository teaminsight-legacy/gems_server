require 'migrations/foreign_keys'

class CreateVersions < ActiveRecord::Migration
  include Migrations::ForeignKeys

  def up
    create_table :versions do |t|
      t.string      :full_name,         :null => false
      t.text        :authors,           :null => false
      t.string      :number,            :null => false
      t.string      :platform,          :null => false
      t.string      :rubyforge_project
      t.text        :summary
      t.text        :description
      t.boolean     :prerelease,        :null => false, :default => false
      t.boolean     :indexed,           :null => false, :default => false
      t.boolean     :latest,            :null => false, :default => false
      t.integer     :rubygem_id,        :null => false
      t.integer     :position
      t.datetime    :built_at
      t.timestamps
    end
    foreign_key :versions, :rubygem_id, :rubygems
    add_index :versions, :full_name
    add_index :versions, :number
    add_index :versions, :platform
    add_index :versions, [ :number, :platform, :rubygem_id ], :unique => true
    add_index :versions, :prerelease
    add_index :versions, :latest
  end

  def down
    remove_index :versions, :latest
    remove_index :versions, :prerelease
    remove_index :versions, [ :number, :platform, :rubygem_id ]
    remove_index :versions, :platform
    remove_index :versions, :number
    remove_index :versions, :full_name
    drop_foreign_key :versions, :rubygem_id
    drop_table :versions
  end
end

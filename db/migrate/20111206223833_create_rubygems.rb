class CreateRubygems < ActiveRecord::Migration
  def change
    create_table :rubygems do |t|
      t.string   :name,       :null => false
      t.integer  :downloads,  :null => false, :default => 0
      t.string   :slug
      t.timestamps
    end
  end
end

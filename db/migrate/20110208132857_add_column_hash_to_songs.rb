class AddColumnHashToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :full_path_hash, :integer
    add_index :songs, :full_path_hash
  end

  def self.down
    remove_column :songs, :full_path_hash
    remove_index :songs, :full_path_hash
  end
end

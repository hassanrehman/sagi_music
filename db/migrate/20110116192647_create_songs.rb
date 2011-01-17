class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.column :name, :string
      t.column :album_id, :integer
      t.column :full_path, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end

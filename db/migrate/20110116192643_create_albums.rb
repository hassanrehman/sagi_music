class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.column :name, :string
      t.column :artist_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end

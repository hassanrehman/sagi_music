class CreateDeleteRequests < ActiveRecord::Migration
  def self.up
    create_table :delete_requests do |t|
      t.column :artist, :string
      t.column :album, :string
      t.column :song, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :delete_requests
  end
end

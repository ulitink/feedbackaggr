class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :loader
      t.string :loader_arg
      t.integer :parent_id
      t.datetime :posted_at
      t.string :url
      t.datetime :cached_at
    end
  end

  def self.down
    drop_table :feeds
  end
end

class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.string :guid
      t.string :title
      t.text :description
      t.string :link
      t.belongs_to :feed
      t.datetime :posted_at
      t.string :author 
    end
  end

  def self.down
    drop_table :records
  end
end

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      #t.database_authenticatable
      #t.rememberable
      t.timestamps
    end
  end

  def self.down
  end
end
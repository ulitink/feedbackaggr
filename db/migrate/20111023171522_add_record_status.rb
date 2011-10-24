class AddRecordStatus < ActiveRecord::Migration
  def self.up
    add_column :records, :status, :integer, :null => false, :default => 0
    add_column :records, :user_id, :integer
  end

  def self.down
    remove_column :records, :status
    remove_column :records, :user_id
  end
end

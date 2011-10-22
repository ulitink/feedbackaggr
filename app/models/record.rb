class Record < ActiveRecord::Base

  belongs_to :feed

  def self.pull_all
    
  end
end

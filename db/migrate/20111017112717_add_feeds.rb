class AddFeeds < ActiveRecord::Migration
  def self.up
    down
    Feed.create!(
        :loader => 'rss_records',
        :loader_arg => 'http://devnet.jetbrains.com/community/feeds/messages?thread=312028'
    )
  end

  def self.down
    Feed.delete_all
  end
end

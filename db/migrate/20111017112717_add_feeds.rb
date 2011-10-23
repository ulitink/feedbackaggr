class AddFeeds < ActiveRecord::Migration
  def self.up
    down
    Feed.create!(
        :loader => 'rss_records',
        :loader_arg => 'http://devnet.jetbrains.com/community/feeds/messages?thread=312028'
    )
    Feed.create!(
        :loader => 'twitter_search',
        :loader_arg => '@jetbrains'
    )
  end

  def self.down
    Record.delete_all # TODO add foreign key
    Feed.delete_all
  end
end

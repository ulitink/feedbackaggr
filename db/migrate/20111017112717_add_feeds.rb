class AddFeeds < ActiveRecord::Migration
  def self.up
=begin TEST DATA

    down
    Feed.create!(
        :loader => 'rss_records',
        :loader_arg => 'http://devnet.jetbrains.com/community/feeds/messages?thread=312028'
    )
    Feed.create!(
        :loader => 'twitter_search',
        :loader_arg => '@jetbrains'
    )
    Feed.create!(
        :loader => 'forum',
        :loader_arg => 'http://devnet.jetbrains.com/community/feeds/threads?community=9778'
    )
=end
  end

  def self.down
=begin TEST DATA
    Record.delete_all # TODO add foreign key to feeds
    Feed.delete_all
=end
  end
end

class Feed < ActiveRecord::Base

  FEED_LOADERS = {
    'rss_records' => FeedLoaders::RssRecordsLoader,
    'twitter_search' => FeedLoaders::TwitterLoader,
    'forum' => FeedLoaders::ForumLoader
  }

  has_many :records
  has_many :child_feeds, :class_name => 'Feed', :foreign_key => 'parent_id'

  def update_content!
    loader = FEED_LOADERS[self.loader]
    loader.update_feed!(self)
  end
end

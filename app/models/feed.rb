class Feed < ActiveRecord::Base

  STRATEGY_BY_LOADER = {
    'rss_records' => FeedLoaders::RssRecordsLoader,
    'twitter_search' => FeedLoaders::TwitterLoader,
    'forum' => FeedLoaders::ForumLoader
  }

  has_many :records
  has_many :child_feeds, :class_name => 'Feed', :foreign_key => 'parent_id'

  validates_format_of :loader_arg,
                      :with => /devnet.jetbrains.com\/community\/feeds\/threads\?community=\d+$/i,
                      :if => Proc.new { |feed| feed.loader == 'forum' }

  def update_content
    loader = STRATEGY_BY_LOADER[self.loader]
    loader.update_feed(self)
  end

end

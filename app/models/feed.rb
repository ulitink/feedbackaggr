class Feed < ActiveRecord::Base

  STRATEGY_BY_LOADER = {
    'rss_records' => FeedLoaders::RssRecordsLoader,
    'twitter_search' => FeedLoaders::TwitterLoader,
    'forum' => FeedLoaders::ForumLoader
  }

  has_many :records
  has_many :child_feeds, :class_name => 'Feed', :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => 'Feed', :foreign_key => 'parent_id'
  has_and_belongs_to_many :users

  validates_inclusion_of :loader, :in => STRATEGY_BY_LOADER.keys
  validates_format_of :loader_arg,
                      :with => /devnet.jetbrains.com\/community\/feeds\/threads\?community=\d+$/i,
                      :if => Proc.new { |feed| feed.loader == 'forum' }

  def update_content
    loader = STRATEGY_BY_LOADER[self.loader]
    loader.update_feed(self)
  end

end

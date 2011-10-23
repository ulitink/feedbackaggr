class Feed < ActiveRecord::Base

  FEED_LOADERS = {'rss_records' => FeedLoaders::RssRecordsLoader, 'twitter_search' => FeedLoaders::TwitterLoader}

  has_many :records

  def update_content!
    loader = FEED_LOADERS[self.loader]
    if loader.child_type == :record
      records = loader.update_feed!(self)
    elsif loader.CHILD_TYPE == :feed
    else
      #TODO throw error
    end
  end
end

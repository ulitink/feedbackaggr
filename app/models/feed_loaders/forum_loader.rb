module FeedLoaders
  require 'net/http'
  require 'rss'

  class ForumLoader
    def self.child_type
      :feed
    end

    # @param feed [Feed]
    def self.update_feed!(feed)
     rss_text = Net::HTTP.get URI.parse(feed.loader_arg)
     rss = RSS::Parser.parse(rss_text)
     feed.cached_at = DateTime.now
     rss.channel.items.each { |item|
       rss_feed_url = "http://devnet.jetbrains.com/community/feeds/messages?thread=#{item.link.rpartition(/[\/\\]/)[2]}"
       child_feed = Feed.find_by_loader_and_loader_arg('rss_records', rss_feed_url)
       if child_feed.nil?
         child_feed = Feed.new(
             :loader => 'rss_records',
             :loader_arg => rss_feed_url,
             :parent_id => feed.id,
             :url => item.link,
             :posted_at => item.pubDate.to_datetime,
             :cached_at => DateTime.now
         )
         child_feed.save
       end
       # TODO check that record content wasn't changed
      }
      child_feeds = feed.child_feeds
      child_feeds.each { |child_feed| update_feed!(child_feed) }
    end
  end
end


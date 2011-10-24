module FeedLoaders
  require 'net/http'
  require 'rss'

  class ForumLoader

    # Recaches forum thread list and recursively each thread messages by specified RSS topic url
    #
    # RSS example: http://devnet.jetbrains.com/community/feeds/threads?community=9778
    #
    # @param feed [Feed]
    def self.update_feed(feed)
      unless feed.loader == 'forum'
        Rails.logger.error 'Wrong argument for ForumLoader.update_feed. feed.id= '+feed.id
        return
      end
      rss_text = Net::HTTP.get URI.parse(feed.loader_arg)
      rss = RSS::Parser.parse(rss_text)
      feed.cached_at = DateTime.now
      rss.channel.items.each do |item|
        unless correct_child_link? item.link
          Rails.logger.error "Wrong link format in forum(id=#{feed.id}) RSS item: #{item.link}"
          next
        end
        rss_feed_url = "http://devnet.jetbrains.com/community/feeds/messages?thread=#{item.link.rpartition(/[\/\\]/)[2]}"
        child_feed = Feed.find_by_loader_and_loader_arg('rss_records', rss_feed_url)
        child_feed ||= Feed.new(
            :loader => 'rss_records',
            :loader_arg => rss_feed_url,
            :parent_id => feed.id,
            :url => item.link,
            :posted_at => item.pubDate.to_datetime
        )
        child_feed.save
      end
      feed.cached_at = DateTime.now
      child_feeds = feed.child_feeds
      child_feeds.each { |child_feed| child_feed.update_content }
    end

    private

    def self.correct_child_link?(url)
      url =~ /http:\/\/devnet.jetbrains.net\/thread\/\d+/
    end
  end

end


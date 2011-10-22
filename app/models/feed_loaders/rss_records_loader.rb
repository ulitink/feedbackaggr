module FeedLoaders
  require 'net/http'
  require 'rss'

  class RssRecordsLoader
    def self.child_type 
      :record
    end
    # Updates feed by reading rss content by url specified in loader_arg
    # @param [Feed, #read] feed
    # @return [void]
    def self.update_feed!(feed)
      rss_text = Net::HTTP.get URI.parse(feed.loader_arg)
      rss = RSS::Parser.parse(rss_text)
      feed.cached_at = DateTime.now
      feed_records = feed.records
      rss_records = rss.channel.items.each { |item|
        record = Record.find_by_guid item.guid.content
        if record.nil?
          record = Record.new(
              :guid => item.guid.content,
              :feed => feed,
              :title => item.title,
              :description => item.description,
              :link => item.link,
              :posted_at => item.pubDate.to_datetime,
              :author => item.author
          )
          record.save
        end
        # TODO check that record content wasn't changed
      }
    end

  private

    def self.feed_of_rss_item(item)
      #item.
    end
  end

end
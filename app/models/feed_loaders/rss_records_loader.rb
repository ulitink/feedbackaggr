module FeedLoaders
  require 'net/http'
  require 'rss'

  class RssRecordsLoader

    # Updates feed by reading rss content by url specified in loader_arg
    #
    # @param [Feed, #read] feed
    #
    # @return [void]
    def self.update_feed(feed)
      unless feed.loader == 'rss_records'
        Rails.logger.error 'Wrong argument for RssRecordsLoader.update_feed. feed.id= '+feed.id
        return
      end
      rss_text = Net::HTTP.get URI.parse(feed.loader_arg)
      rss = RSS::Parser.parse(rss_text)
      rss.channel.items.each do |item|
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
      end
      # TODO delete from cache remotely deleted records
      feed.cached_at = DateTime.now
      feed.save
    end

  end

end
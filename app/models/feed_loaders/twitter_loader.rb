module FeedLoaders
  require 'net/http'
  require 'twitter'

  class TwitterLoader

    # Updates feed by executing twitter search by loader_arg
    # @param [Feed, #read] feed
    # @return [void]
    def self.update_feed(feed)
      unless feed.loader == 'twitter_search'
        Rails.logger.error 'Wrong argument for TwitterLoader.update_feed. feed.id= '+feed.id
        return
      end

      search_str = feed.loader_arg
      search = Twitter::Search.new.contains(search_str)
      twits = search.fetch
      twits.each do |twit|
        guid = get_guid(twit)
        record = Record.find_by_guid guid
        if record.nil?
          record = Record.new(
              :guid => guid,
              :feed => feed,
              :title => search_str,
              :description => twit.text,
              :link => "http://twitter.com/#{twit.from_user}/status/#{twit.id_str}",
              :posted_at => twit.created_at.to_datetime,
              :author => twit.from_user
          )
          record.save
        end
      end
      feed.cached_at = DateTime.now
      feed.save
    end
    
    private

    def self.get_guid(twit)
      "twit/#{twit.from_user}/#{twit.id_str}"
    end
  end
end
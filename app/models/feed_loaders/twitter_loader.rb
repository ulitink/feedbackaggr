module FeedLoaders
  require 'net/http'
  require 'twitter'

  class TwitterLoader

    def self.child_type
      :record
    end

    # Updates feed by executing twitter search by loader_arg
    # @param [Feed, #read] feed
    # @return [void]
    def self.update_feed!(feed)
      # TODO assert feed.type=twitter
      search_str = feed.loader_arg
      search = Twitter::Search.new.contains(search_str)
      twits = search.fetch
      feed.cached_at = DateTime.now
      feed_records = feed.records
      twits.each { |twit|
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
        # TODO check that record content wasn't changed
      }
    end
    
    private

    def self.get_guid(twit)
      "twit/#{twit.from_user}/#{twit.id_str}"
    end
  end # Class TwitterLoader

end
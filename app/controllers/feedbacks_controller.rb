class FeedbacksController < ApplicationController
  def list
    feeds = Feed.all
    @records ||= []
    feeds.each { |feed|
      feed.update_content!
      @records = @records + feed.records
    }
    @records.sort! { |x,y| y.posted_at <=> x.posted_at }
  end
end

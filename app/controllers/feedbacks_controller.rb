class FeedbacksController < ApplicationController
  def list
    feed = Feed.first
    feed.update_content!
    @records = feed.records
  end
end

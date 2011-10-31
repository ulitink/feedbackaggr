class ProfilesController < ApplicationController

  LOADER_ARG_DESCRIPTION = {
    'rss_records' => 'Posts RSS url (http://devnet.jetbrains.com/community/feeds/messages?thread=313817)',
    'twitter_search' => 'Twitter search string (@jetbrains)',
    'forum' => 'Forum threads RSS url (http://devnet.jetbrains.com/community/feeds/threads?community=9778)'
  }
  
  def new_watched_feed
    watched_feed = Feed.find_by_loader_and_loader_arg(params[:feed][:loader], params[:feed][:loader_arg])
    watched_feed ||= Feed.new(params[:feed])
    watched_feed.users << current_user
    watched_feed.save
    @watched_feeds = get_watched_feeds_paginated
    render :update do |page|
      page.replace_html 'errors', error_messages_for(watched_feed)
      page.replace_html 'watched_feeds', :partial => 'watched_feed', :collection => @watched_feeds
    end
  end

  def edit
    @watched_feeds = get_watched_feeds_paginated
  end

  def remove_watched_feed
    feed = Feed.find(params[:id])
    current_user.feeds.delete(feed)
    users_watching = feed.users #.where(['users.id <> ?', current_user.id])
    if users_watching.length == 0 then
      feed.delete
    end
    @watched_feeds = get_watched_feeds_paginated
    render :update do |page|
      page.replace_html 'watched_feeds', :partial => 'watched_feed', :collection => @watched_feeds
    end
  end

  private

  def get_watched_feeds_paginated
    Feed.includes(:users).where(['users.id = ?', current_user.id]).paginate(:page => params[:page])
  end

end

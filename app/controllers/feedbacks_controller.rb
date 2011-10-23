class FeedbacksController < ApplicationController
  def list
    feeds = Feed.all
    @records ||= []
    feeds.each { |feed|
      #feed.update_content!
      @records = @records + feed.records
    }
    @records.sort! { |x,y| y.posted_at <=> x.posted_at }
  end

  def update_status
    record = Record.find(params[:id])
    record.status = params[:status]
    record.user = current_user
    record.save
    render :update do |page|
      page.replace_html("record#{record.id}", render(:partial => 'record', :locals => { :record => record }))
    end
  end

end

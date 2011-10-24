class FeedbacksController < ApplicationController
  def list
    feeds = Feed.all
    feeds.each { |feed| feed.update_content }
    @records = Record.all(:order => 'posted_at DESC')
  end

  def update_status
    record = Record.find(params[:id])
    record.status = params[:status]
    record.user = current_user
    record.save
    render :update do |page|
      page.replace("record#{record.id}", render(:partial => 'record', :locals => { :record => record }))
    end
  end

end

class FeedbacksController < ApplicationController
  def list
    set_fields
  end

  def update_posts
    feeds = Feed.find_all_by_parent_id(nil)
    feeds.each { |feed| feed.update_content }
    #fake_record = Record.new(
    #          :title => "FAKE RECORD",
    #          :description => "It's really only for testing'",
    #          :link => "",
    #          :posted_at => DateTime.now,
    #          :author => "kostya"
    #      )
    #fake_record.save
    records = Record.paginate(:page => params[:page]).order('posted_at DESC')
    record_ids = records.map { |r| r.id }
    page_record_ids = params[:record_ids].split(',').map! { |s_id| s_id.to_i }
    added_records = records.delete_if { |record| page_record_ids.include?(record.id) }
    removed_records = (page_record_ids - record_ids).map! { |id| 'record' + id.to_s}
    render :update do |page|
      removed_records.each { |element_id| page.remove element_id }
      added_records.each do |record|
        page.insert_html(:top, 'feedback_list', :partial => 'record', :locals => { :record => record })
      end
    end
  end

  def update_status
    record = Record.find(params[:id])
    record.status = params[:status]
    record.user = current_user
    record.save
    render :update do |page|
      page.replace("record#{record.id}", :partial => 'record', :locals => { :record => record })
    end
  end

  def update_filter
    set_fields
    render :update do |page|
      page.replace('content', :template => 'feedbacks/list')
    end
  end

  private

  def set_fields
    if !params[:filter].nil? && params[:filter][:only_watched]=='true'
      @records = current_user.watched_records(params[:page])
      @filters = {:only_watched => true}
    else
      @records = Record.paginate(:page => params[:page]).order('posted_at DESC')
      @filters = {:only_watched => false}
    end
  end

end

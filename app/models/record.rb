class Record < ActiveRecord::Base

  STATUSES = [:unread, :in_progress, :resolved]

  belongs_to :feed
  belongs_to :user


  def status
    STATUSES[read_attribute(:status)]
  end

  def status=(value)
    if value.instance_of? Integer then
      write_attribute(:status, value)
    elsif value.instance_of? String then
      write_attribute(:status, value.to_i)
    elsif value.instance_of? Symbol then
      write_attribute(:status, STATUSES.index(value))
    end
  end

end

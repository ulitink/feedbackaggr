class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_and_belongs_to_many :feeds

  def full_name
    #TODO add name and surname
    email.rpartition('@')[0]
  end

  def watched_records(page)
    Record.paginate(:page => page).find(
        :all,
        :joins => 'JOIN feeds child_feeds  ON records.feed_id=child_feeds.id' <<
            ' LEFT OUTER JOIN feeds parent_feeds ON parent_feeds.id=child_feeds.parent_id' <<
            ' JOIN feeds_users ON feeds_users.feed_id=parent_feeds.id OR feeds_users.feed_id=child_feeds.id',
        :conditions => ['feeds_users.user_id = ?', id],
        :order => 'posted_at DESC'
        )
  end
end

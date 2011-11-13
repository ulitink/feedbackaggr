require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "wrong email format" do
    user = User.new
    user.email = 'wrongemail'
    user.encrypted_password = Devise.friendly_token
    assert !user.save
  end

  test "watched feed" do
    user = users(:phpstorm)
    watched_records = user.watched_records(1)
    assert_equal watched_records.length, 1
    assert_equal watched_records[0], records(:thread_1)
  end

end

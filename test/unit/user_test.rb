require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "wrong email format" do
    user = User.new
    user.email = 'wrongemail'
    user.encrypted_password = Devise.friendly_token
    assert !user.save
  end

end

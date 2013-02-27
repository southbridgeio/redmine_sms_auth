require File.expand_path('../../test_helper', __FILE__)

class UserPatchTest < ActiveSupport::TestCase
  fixtures :users, :roles

  def setup
    auth_source = AuthSourceSms.create(name: 'SMS', onthefly_register: false, tls: false)
    @user = User.find(2) # jsmith
    @user.update_attribute :auth_source_id, auth_source.id
  end

  def test_password_changing
    old_password = @user.hashed_password
    @user.password_confirmation = @user.password = 'new_password'
    @user.save
    @user.reload
    assert @user.hashed_password != old_password
  end
end
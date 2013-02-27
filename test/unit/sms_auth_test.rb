require File.expand_path('../../test_helper', __FILE__)

class SmsAuthTest < ActiveSupport::TestCase

  def test_generate_sms_password
    SmsAuth::Configuration.expects(:password_length).returns(5)
    password = SmsAuth.generate_sms_password
    assert password.length == 5
  end

  def test_send_sms_password
    SmsAuth::Configuration.expects(:send_command).returns('echo %{phone} %{password}')
    SmsAuth.expects(:system).with('echo 79999999999 1234')
    SmsAuth.send_sms_password('79999999999', '1234')
  end

end
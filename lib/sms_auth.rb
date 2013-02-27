module SmsAuth

  module Configuration

    def self.send_command
      configuration = Redmine::Configuration['sms_auth']
      configuration && configuration['send_command'] ? configuration['send_command'] : 'notify-send %{phone} %{password}'
    end

    def self.password_length
      configuration = Redmine::Configuration['sms_auth']
      configuration && configuration['password_length'] && configuration['password_length'].to_i > 0 ?
          configuration['password_length'].to_i : 4
    end

  end

  def self.generate_sms_password
    Random.srand
    sms_password_degree = 10 ** (SmsAuth::Configuration.password_length - 1)
    (rand(9 * sms_password_degree) + sms_password_degree).to_s
  end

  def self.send_sms_password(phone, password)
    phone = phone.gsub(/[^0-9]+/,'') # Additional phone sanitizing
    send_command = SmsAuth::Configuration.send_command
    send_command = send_command.sub('%{phone}', phone).sub('%{password}', password)
    system send_command
  end

end
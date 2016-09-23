class AddSmsAuth < ActiveRecord::Migration
  def up
    AuthSourceSms.create name: 'SMS', onthefly_register: false, tls: false
  end

  def down
    AuthSource.where(type: 'AuthSourceSms').destroy_all
    if Redmine::Plugin.installed?(:redmine_2fa)
      Redmine2FA::AuthSourceSms.create name: 'SMS', onthefly_register: false, tls: false
    end
  end
end

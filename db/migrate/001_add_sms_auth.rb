class AddSmsAuth < ActiveRecord::Migration
  def up
    AuthSourceSms.create name: 'SMS', onthefly_register: false, tls: false
  end

  def down

    if Redmine::Plugin.installed?(:redmine_2fa)
      old_auth_source    = AuthSource.where(type: 'AuthSourceSms').first
      old_auth_source_id = if old_auth_source
                             old_auth_source.id
                           else
                             (User.all.pluck(:auth_source_id).compact.uniq - AuthSource.pluck(:id)).first
                           end

      AuthSource.where(type: 'AuthSourceSms').destroy_all

      new_auth_source = Redmine2FA::AuthSourceSms.create name: 'SMS', onthefly_register: false, tls: false

      if old_auth_source_id
        User.where(auth_source_id: old_auth_source_id).update_all(auth_source_id: new_auth_source.id)
      end
    else
      AuthSource.where(type: 'AuthSourceSms').destroy_all
    end
  end
end

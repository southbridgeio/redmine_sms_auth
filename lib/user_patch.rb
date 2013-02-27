require_dependency 'project'
require_dependency 'user'

module UserPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.safe_attributes 'mobile_phone'
    base.validates_format_of :mobile_phone, :with => /^[0-9]*$/, :allow_blank => true
    base.class_eval do
      alias_method_chain :update_hashed_password, :sms_auth
    end
  end

  module InstanceMethods

    def update_hashed_password_with_sms_auth
      if self.auth_source && self.auth_source.auth_method_name == 'SMS'
        salt_password(self.password) if self.password
      else
        update_hashed_password_without_sms_auth
      end
    end

  end

end

User.send(:include, UserPatch)
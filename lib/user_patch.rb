require_dependency 'project'
require_dependency 'user'

module UserPatch

  def self.included(base)
    base.safe_attributes 'mobile_phone'
    base.validates_format_of :mobile_phone, :with => /^[0-9]*$/, :allow_blank => true
  end

end

User.send(:include, UserPatch)
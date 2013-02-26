require_dependency 'project'
require_dependency 'user'

module UserPatch

  def self.included(base)
    base.safe_attributes 'mobile_phone'
  end

end

User.send(:include, UserPatch)
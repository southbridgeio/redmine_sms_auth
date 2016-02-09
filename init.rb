Redmine::Plugin.register :redmine_sms_auth do
  name 'Redmine SMS Auth plugin'
  author 'Centos-admin.ru'
  description 'Plugin adds secondary sms authentication'
  version '0.0.4'
  url 'https://github.com/centosadmin/redmine_2auth'
  author_url 'http://centos-admin.ru'
end

ActionDispatch::Callbacks.to_prepare do
  require 'sms_auth'
  require_dependency 'redmine_2auth/hooks'
  require_dependency 'account_controller_patch'
  require_dependency 'user_patch'
end

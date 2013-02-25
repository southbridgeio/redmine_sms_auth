RedmineApp::Application.routes.draw do
  post :sms_confirm, to: 'account#sms_confirm', as: :sms_confirm
end

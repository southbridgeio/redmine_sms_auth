RedmineApp::Application.routes.draw do
  post :sms_confirm, to: 'account#sms_confirm', as: :sms_confirm
  get :sms_resend, to: 'account#sms_resend', as: :sms_resend
end

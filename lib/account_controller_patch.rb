require_dependency 'account_controller'

module AccountControllerPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :password_authentication, :sms_auth
    end
  end

  module InstanceMethods

    def sms_confirm
      if session[:sms_user_id] && session[:sms_password]
        if session[:sms_password] == params[:sms_password].to_s
          user = User.find(session[:sms_user_id])
          successful_authentication(user)
        else
          flash[:error] = l(:notice_account_invalid_sms_password)
          render 'sms'
        end
      else
        redirect_to root_path
      end
    end

    private

    def password_authentication_with_sms_auth
      user = User.where(login: params[:username].to_s).first
      if user && user.auth_source && user.auth_source.auth_method_name == 'SMS'
        if User.hash_password("#{user.salt}#{User.hash_password params[:password]}") == user.hashed_password
          session[:sms_password] = (rand(9000) + 1000).to_s # TODO configurable length
          session[:sms_user_id] = user.id
          system "notify-send #{session[:sms_password]}" # TODO make configurable shell command
          render 'sms'
        end
      else
        password_authentication_without_sms_auth
      end
    end

  end

end

AccountController.send(:include, AccountControllerPatch)

# TODO add 'send_again' action
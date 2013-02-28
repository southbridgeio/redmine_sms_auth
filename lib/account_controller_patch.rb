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
        user = User.find(session[:sms_user_id])
        if session[:sms_password] == params[:sms_password].to_s
          session[:sms_user_id] = nil
          session[:sms_password] = nil
          session[:sms_failed_attempts] = nil
          successful_authentication(user)
        else
          session[:sms_failed_attempts] ||= 0
          session[:sms_failed_attempts] += 1
          if session[:sms_failed_attempts] >= 3
            regenerate_sms_password(user)
            flash[:error] = l(:notice_account_sms_limit_exceeded_failed_attempts)
          else
            flash[:error] = l(:notice_account_invalid_sms_password)
          end
          render 'sms'
        end
      else
        redirect_to '/'
      end
    end

    def sms_resend
      if session[:sms_user_id] && session[:sms_password]
        user = User.find(session[:sms_user_id])
        regenerate_sms_password(user)
        flash[:notice] = l(:notice_account_sms_resent_again)
        render 'sms'
      else
        redirect_to '/'
      end
    end

    private

    def password_authentication_with_sms_auth
      user = User.where(login: params[:username].to_s).first
      if user && user.auth_source && user.auth_source.auth_method_name == 'SMS' && !user.mobile_phone.blank?
        if User.try_to_login(params[:username], params[:password]) == user
          session[:sms_user_id] = user.id
          regenerate_sms_password(user)
          render 'sms'
        else
          invalid_credentials
        end
      else
        password_authentication_without_sms_auth
      end
    end

    def regenerate_sms_password(user)
      session[:sms_password] = SmsAuth.generate_sms_password
      SmsAuth.send_sms_password(user.mobile_phone, session[:sms_password])
      session[:sms_failed_attempts] = 0
    end

  end

end

AccountController.send(:include, AccountControllerPatch)
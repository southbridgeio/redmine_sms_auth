class AuthSourceSms < AuthSource
  def authenticate(login, password)
    # Just stub
  end

  def auth_method_name
    'SMS'
  end
end
# TODO make password changeable
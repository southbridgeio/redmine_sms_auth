# Redmine SMS Auth

Plugin adds SMS-authentication to [Redmine](http://www.redmine.org/). Plugin compatible with Redmine 2.0.x, 2.1.x, 2.2.x, 2.3.x

## Some notes

Because there are many sms-gateways with different API, the responsibility on sending sms-message falls to external command. It can be any shell script or command like `curl`, e.g.
```
curl http://my-sms-gateway.net?phone=%{phone}&message=%{password}
```
`%{phone}` and `%{password}` are placeholders. They will be replaced with actual data during runtime. Default command is `echo %{phone} %{password}`.

Default password length is 4.

If user's mobile phone is blank, plugin authenticates him with password checking only.

## WARNING

All **rake** commands must be run with correct **RAILS_ENV** variable, e.g.
```
RAILS_ENV=production rake redmine:plugins:migrate
```

## Installation

1. Stop redmine

2. Clone repository to your redmine/plugins directory
```
git clone git://github.com/olemskoi/redmine_sms_auth.git
```

3. Install dependencies
```
bundle install
```

4. Run migration
```
rake redmine:plugins:migrate
```

5. Add command for sms sending (and optionally password length) to configuration.yml
```yaml
    production:
      sms_auth:
        command: 'echo %{phone} %{password}'
        password_length: 5
```

6. Run redmine

7. Set 'Authentication mode' to 'SMS' for each user (Administration - Users)
8. (Optionally) Set mobile phone number for each user. Also user can set number for himself.

## Uninstall

1. Set 'Authentication mode' to 'Internal' for each user (Administration - Users)

2. Stop redmine.

3. Remove 'sms_auth' section from configuration.yml

4. Rollback migration
```
rake redmine:plugins:migrate VERSION=0 NAME=redmine_sms_auth
```

5. Remove plugin directory from your redmine/plugins directory

## Sponsors

Work on this plugin was fully funded by [centos-admin.ru](http://centos-admin.ru)

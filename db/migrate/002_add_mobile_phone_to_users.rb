class AddMobilePhoneToUsers < ActiveRecord::Migration
  def up
    unless column_exists? :users, :mobile_phone
      add_column :users, :mobile_phone, :string
    end

  end

  def down
    unless Redmine::Plugin.installed?(:redmine_2fa)
      remove_column :users, :mobile_phone
    end
  end
end

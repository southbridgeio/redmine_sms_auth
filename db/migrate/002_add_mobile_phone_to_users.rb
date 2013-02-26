class AddMobilePhoneToUsers < ActiveRecord::Migration
  def up
    add_column :users, :mobile_phone, :string
  end

  def down
    remove_column :users, :mobile_phone
  end
end

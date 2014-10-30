class AddUidToUsersAndChangeValidations < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    change_column :users, :email, :string, null: true
    change_column :users, :college_id, :integer, null: true
  end
end

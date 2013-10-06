class AddUserEndUserJoinTable < ActiveRecord::Migration
  def change
    create_table :end_users_users, :id => false do |t|
      t.references :user, :null => false
      t.references :end_user, :null => false
    end

    add_index(:end_users_users, [:user_id, :end_user_id], :unique => true)
  end
end

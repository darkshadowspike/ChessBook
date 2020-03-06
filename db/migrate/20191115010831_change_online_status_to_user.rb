class ChangeOnlineStatusToUser < ActiveRecord::Migration[5.2]
  def change
  	remove_column :users, :online
  	add_column :users, :online_at, :datetime
  end
end

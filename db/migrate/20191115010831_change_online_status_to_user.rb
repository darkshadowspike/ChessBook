class ChangeOnlineStatusToUser < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :online, :online_at
  	change_column :users, :online_at, :datetime
  end
end

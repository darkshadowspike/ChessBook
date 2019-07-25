class RelationshipRenameIds < ActiveRecord::Migration[5.2]
  def change
  	rename_column :relationships, :friend_active, :friend_active_id
  	rename_column :relationships, :friend_pasive, :friend_pasive_id
   
  end
end

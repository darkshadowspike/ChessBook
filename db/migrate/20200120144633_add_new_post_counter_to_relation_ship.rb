class AddNewPostCounterToRelationShip < ActiveRecord::Migration[5.2]
  def change
  	add_column :relationships, :friend_active_new_posts, :integer, default: 0
  	add_column :relationships, :friend_pasive_new_posts, :integer, default: 0
  end
end

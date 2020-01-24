class AddNewRequestToRelationships < ActiveRecord::Migration[5.2]
  def change
  	add_column :relationships, :new_request, :boolean, default: true
  end
end

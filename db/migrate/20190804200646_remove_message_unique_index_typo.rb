class RemoveMessageUniqueIndexTypo < ActiveRecord::Migration[5.2]
  def change
  	remove_index :messages, [:sender_id, :receiver_id]
  	add_index :messages, [:sender_id, :receiver_id]
  end
end

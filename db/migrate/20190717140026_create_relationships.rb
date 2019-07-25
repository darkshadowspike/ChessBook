class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :friend_active
      t.integer :friend_pasive
      t.boolean :accepted, default: false

      t.timestamps
    end
    add_index :relationships, :friend_active
    add_index :relationships, :friend_pasive
    add_index :relationships, [:friend_active, :friend_pasive], unique: true
  end
end

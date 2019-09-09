class CreateChessgames < ActiveRecord::Migration[5.2]
  def change
    create_table :chessgames do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.json :gamesave
      t.timestamps
    end

    add_index :chessgames, :player1_id
    add_index :chessgames, :player2_id
    add_index :chessgames, [:player1_id, :player2_id]
  end
end

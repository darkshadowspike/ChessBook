class AddTurnsToChessgame < ActiveRecord::Migration[5.2]
  def change
  	add_column :chessgames, :player1_turn, :boolean, default: true
  end
end

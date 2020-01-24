class AddFirstTurnMarkerToChessgame < ActiveRecord::Migration[5.2]
  def change
  	add_column :chessgames, :first_turn, :boolean, default: true
  end
end

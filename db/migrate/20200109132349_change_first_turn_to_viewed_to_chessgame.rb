class ChangeFirstTurnToViewedToChessgame < ActiveRecord::Migration[5.2]
  def change
  	rename_column :chessgames, :first_turn, :viewed_play
  	change_column :chessgames, :viewed_play, :boolean, default: false
  end
end

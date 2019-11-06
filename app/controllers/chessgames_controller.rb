class ChessgamesController < ApplicationController

	def create
		@friend = User.find(chessgame_params[:friend_id].to_i)
		@chessgame = current_user.game_with_user(@friend)
		@chessgame.destroy
		@chessgame = current_user.game_with_user(@friend)
		unless @chessgame
			@relationship = Relationship.friendship(current_user.id, @friend.id)
			@chessgame = current_user.game_as_player1.create(player2_id: @friend.id)

			ActionCable.server.broadcast "game_#{@relationship.id}_channel", 
			new_game: true

		end
		
		redirect_to gamechat_url(friend_id: @friend.id)
	end

	def update
		@chessgame = Chessgame.find(params[:id])
		@chessgame.load_board
		@chessgame.piece_move(chessgame_params[:start_pos], chessgame_params[:new_pos])
		@relationship = Relationship.friendship(current_user.id, chessgame_params[:friend_id].to_i)
		ActionCable.server.broadcast "game_#{@relationship.id}_channel", 
		new_game: false,
		move_info:[chessgame_params[:start_pos], chessgame_params[:new_pos] ],
		player_data: JSON.parse(@chessgame.play)

	end

	private 

	def chessgame_params
		params.require(:chessgame).permit(:friend_id, :start_pos, :new_pos)
	end

end

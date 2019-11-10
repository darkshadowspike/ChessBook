class Chessgame < ApplicationRecord
	require 'chess/board.rb'
	require 'chess/pawn.rb'
	require 'chess/rook.rb'
	require 'chess/knight.rb'
	require 'chess/bishop.rb'
	require 'chess/queen.rb'
	require 'chess/king.rb'
	attr_accessor :board

	before_save :create_board

	belongs_to :player1, class_name: "User"
	belongs_to :player2, class_name: "User"
	validates :player1_id, :player2_id, presence: true

	def play
		if board
			play_info = board.playable_pieces(player1_turn)
			return play_info.to_json
		end
	end

	def is_valid?(start_pos, new_pos)
		if board
			return board.valid_move?(start_pos, new_pos, player1_turn)
		end
	end

	def piece_move(start_pos, new_pos,promotion)
		moves = board.alegebraic_chess_notation_to_cordenates(start_pos, new_pos)
		board.move_piece(moves[0], moves[1], promotion)
		update_columns(gamesave: board.to_json, player1_turn: !player1_turn)
	end

	def load_board
		self.board = Board.new(true)
		data = JSON.parse(gamesave)
		data["nodes"].each do |piece|
					piecename = piece["name"]
					case piecename
						when "Pawn"
							board.put_piece( Pawn.new( piece["data"]["pos"],piece["data"]["symbol"],piece["data"]["white"], board) )
						when "Rook"
							board.put_piece( Rook.new( piece["data"]["pos"],piece["data"]["symbol"],piece["data"]["white"], board ) )
						when "Bishop"
							board.put_piece( Bishop.new( piece["data"]["pos"],piece["data"]["symbol"],piece["data"]["white"], board ) )
						when "Knight"
							board.put_piece( Knight.new( piece["data"]["pos"],piece["data"]["symbol"],piece["data"]["white"], board ) )
						when "Queen"
							board.put_piece( Queen.new( piece["data"]["pos"],piece["data"]["symbol"],piece["data"]["white"], board ) )
						when "King"
							board.put_piece( King.new( piece["data"]["pos"],piece["data"]["symbol"],piece["data"]["white"], board ), true )
					end

		end
	end

	private

	def create_board
   		self.board = Board.new
   		self.gamesave =	board.to_json
   	end
end

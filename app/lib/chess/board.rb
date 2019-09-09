class Board
	include Chess::Pieces
	#try to remove positions instace variables
	attr_accessor :spaces, :whites_pieces, :black_pieces, :white_positions, :black_positions, :white_king, :black_king
	
	def initialize(loadgame = false)
		@white_pieces = []
		@black_pieces = []
		@white_positions = []
		@black_positions =[]
		@white_king = nil
		@black_king = nil
		@spaces = [[],[],[],[],[],[],[],[]]
		set_table

	end

	def put_black
		i = 1
		while i <= 8 do 
			put_piece(Pawn.new([i,7],"\u265F",false))
			i += 1
		end
    	put_piece(Rook.new([1,8],"\u265C",false))
     	put_piece(Rook.new([8,8],"\u265C",false))
     	put_piece(Knight.new([2,8],"\u265E",false))
     	put_piece(Knight.new([7,8],"\u265E",false))
     	put_piece(Bishop.new([3,8],"\u265D",false))
     	put_piece(Bishop.new([6,8],"\u265D",false))
     	put_piece(Queen.new([4,8],"\u265B",false))
    	put_piece(King.new([5,8],"\u265A",false))

	end 

	def put_white
		i = 1
		while i <= 8 do 
			put_piece(Pawn.new([i,2],"\u2659",true))
			i += 1
		end
		put_piece(Rook.new([1,1],"\u2656",true))
		put_piece(Rook.new([8,1],"\u2656",true))
		put_piece(Knight.new([2,1],"\u2658",true))
		put_piece(Knight.new([7,1],"\u2658",true))
		put_piece(Bishop.new([3,1],"\u2657",true))
		put_piece(Bishop.new([6,1],"\u2657",true))
		put_piece(Queen.new([4,1],"\u2655",true))
		put_piece(King.new([5,1],"\u2654",true))
	end

	def put_piece(piece, king = false)
		if piece.white 
			@white_pieces.push(piece)
			if king 
				@white_king = piece
			end
			@white_positions.push(piece.pos)
		else 
			@black_pieces.push(piece)
			if king
				@black_king = piece
			end
			@black_positions.push(piece.pos)
		end
		@spaces[piece.pos[0]-1][piece.pos[1]-1] = piece
	end

	def set_table
		put_white
		put_black
	end

end

require_relative 'node.rb'

#class to make the instance of the nodes
class Piece < Node
		attr_accessor :pos, :symbol ,:white, :neighbours, :board

		def initialize(pos=[0,0],symbol ="", white =true,board)
			#[X,Y]
        	#pos = [X,Y] it indicate its position in the board
			@pos = pos
			#neighbours are the node which have a connection with this node, is used to stablish the posible moves of the piece, its share the index of the node with its index in the graph 
			@neighbours = []
			#symbol of the piece
			@symbol = symbol
			@white = white
			@board = board
		end



		# displays posible moves in letter from

		def posible_moves_letters(blocker = [], limited_moves = [], ignore =[])
			positions  = posible_moves(blocker, limited_moves, ignore )
			positions = positions.map do |pos|	
				text_pos(pos)
			end
			return positions
		end

		#return  an array with the posible moves
		def posible_moves( blocker = [], limited_moves = [], ignore =[] )
			calculate_posible_moves( blocker, limited_moves, ignore)

			pos =[]
			@neighbours.each do |node|
				if node
					pos.push(node.pos)
				end
			end 
			return pos
		end

		def neighbours_includes?(pos)
			@neighbours.each do |node|
				if node && node.pos == pos
					return true
				end
			end
			return false
		end


		def delete_neighbour_if_includes(pos)	
			
			if neighbours_includes?(pos)
				@neighbours = []
			end
		end

		#checks if a move doesn't put king in danger by cheking if ignoring the piece position results in the king becoming avaible for the enemy piece

	    def safe_move(pos)

				@board.nodes.each do |node|
					if @white
						if (node.class == Queen || node.class == Bishop || node.class == Rook ) && !node.white
							if node.neighbours_includes?(@pos)
								original_neighbours = node.neighbours.dup
								node.calculate_posible_moves(pos, [], @pos)
								if node.neighbours_includes?(@board.white_king.pos) && node.pos != pos
									node.neighbours = original_neighbours
									return false
								else
									node.neighbours = original_neighbours
								end
							end
						end
					else
						if (node.class == Queen || node.class == Bishop || node.class == Rook ) && node.white
							if node.neighbours_includes?(@pos)
								original_neighbours = node.neighbours.dup
								node.calculate_posible_moves(pos,[], @pos)
								if node.neighbours_includes?(@board.black_king.pos) && node.pos != pos
									node.neighbours = original_neighbours
									return false
								else
									node.neighbours = original_neighbours
								end
							end											
						end
					end
				end

				return true
		 end		

		#check what moves would stop this piece of threating the king checking its move with a block

		def check_interrupters
			interrupters = []
			original_neighbours = @neighbours.dup
			original_neighbours.each do |node|
				if node
					calculate_posible_moves(node.pos)
					if @white && !neighbours_includes?(@board.black_king.pos)
						interrupters.push(node.pos)
					elsif !@white && !neighbours_includes?(@board.white_king.pos)
						interrupters.push(node.pos)
					end
				end
			end
			@neighbours = original_neighbours
			return interrupters
		end

		def as_json(options={})

			{
			    name: self.class.name,
			    data: {
			    	white: @white,
			    	symbol: @symbol,
			        pos: @pos
			    }
			}
		end






end
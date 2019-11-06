require_relative 'pawn.rb'
require_relative 'rook.rb'
require_relative 'knight.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'king.rb'
require_relative 'node.rb'
#Board is a Graph class that uses instace of nodes and pieces
class Board
		attr_accessor :nodes, :white_king, :black_king, :can_capture_white,  :can_capture_black, :danger_to_wking , :danger_to_bking

		def initialize(loadgame= false)
			@nodes = []
			@can_capture_white = nil 
			@can_capture_black = nil 
			@white_king = nil
			@danger_to_wking = []
			@black_king = nil
			@danger_to_bking = []
			set_table(loadgame)
		end

		# sets the table

		def set_table(loadgame = false)
			put_nodes
			unless loadgame
				put_white
				put_black
			end
		end

		#create nodes to fill the graph/board

		def put_nodes
			x = 0
			while x <=7
				y = 7 
				while y >= 0
					add_node( Node.new(pos = [x,y], board = self)  )
					y -=1
				end
				x+=1

			end
		end



		def put_black
			i = 0
			while i <= 7 do 
				put_piece(Pawn.new([i,6],"\u265F",false,self))
				i += 1
			end
	    	put_piece(Rook.new([0,7],"\u265C",false,self))
	     	put_piece(Rook.new([7,7],"\u265C",false,self))
	     	put_piece(Knight.new([1,7],"\u265E",false,self))
	     	put_piece(Knight.new([6,7],"\u265E",false,self))
	     	put_piece(Bishop.new([2,7],"\u265D",false,self))
	     	put_piece(Bishop.new([5,7],"\u265D",false,self))
	     	put_piece(Queen.new([3,7],"\u265B",false,self))
	    	put_piece(King.new([4,7],"\u265A",false,self), true)

		end 

		def put_white
			i = 0
			while i <= 7 do 
				put_piece(Pawn.new([i,1],"\u2659",true,self))
				i += 1
			end
			put_piece(Rook.new([0,0],"\u2656",true,self))
			put_piece(Rook.new([7,0],"\u2656",true,self))
			put_piece(Knight.new([1,0],"\u2658",true,self))
			put_piece(Knight.new([6,0],"\u2658",true,self))
			put_piece(Bishop.new([2,0],"\u2657",true,self))
			put_piece(Bishop.new([5,0],"\u2657",true,self))
			put_piece(Queen.new([3,0],"\u2655",true,self))
			put_piece(King.new([4,0],"\u2654",true,self) , true)
		end

		def put_piece(piece, king = false)
			if piece.white 
				if king 
					@white_king = piece
				end
			else 
				if king
					@black_king = piece
				end
			end
			add_node(piece)
		end

		def playable_pieces(white = true)
			playable = {
				check: false,
				checkmate: false,
				pieces: []
			}
			if white
					#white pieces
					check = player_in_check?
					@nodes.each do |node|
						if node.class != Node &&  node.white 
							if node.class != King
								unless check
									pos_move = node.posible_moves_letters
								else
									playable[:check] = true
									limited_moves = []
									limited_moves.push(@can_capture_white.pos) 
									limited_moves += @can_capture_white.check_interrupters
								    pos_move = node.posible_moves_letters([] ,limited_moves)								
								end 
							else
								pos_move = node.posible_moves_letters(@danger_to_wking)
						    end

							if  pos_move.any?  
								piece =  {piece: "#{node.class}" ,pos: "#{node.text_pos}", posible_moves:  pos_move}
								playable[:pieces].push(piece)
							end

						end
					end

			else
					#black pieces
					check = player_in_check?(false)
					@nodes.each do |node|
						if node.class != Node && !node.white 
							if node.class != King
								unless check								
									pos_move = node.posible_moves_letters
								else
									playable[:check] = true
									limited_moves = []
									limited_moves.push(@can_capture_black.pos) 
									limited_moves += @can_capture_black.check_interrupters
									pos_move = node.posible_moves_letters([] ,limited_moves)									
								end 
							else 
								pos_move = node.posible_moves_letters(@danger_to_bking)
							end

							if  pos_move.any?  
								piece =  {piece: "#{node.class}" ,pos: "#{node.text_pos}", posible_moves:  pos_move}
								playable[:pieces].push(piece)
							end

						end
					end

			end
			if !playable[:pieces].any?
				playable[:checkmate] = true
			end
			return playable
		end

		#check if a piece is treathing the king and pushes the dangerous move for the king, important to before checking the posible moves

		def player_in_check?(white = true)
				in_check = false
				if white
					@nodes.each do |node|
						if node.class != Node  && !node.white 
							node.posible_moves
							if node.neighbours_includes?(@white_king.pos)
								@can_capture_white  = node
								in_check = true
							end
						end
					end	
				else
					@nodes.each do |node|
						if node.class != Node  &&  node.white 
							node.posible_moves
							if node.neighbours_includes?(@black_king.pos)
								@can_capture_black  = node
								in_check = true
							end
						end
					end						
				end
			    return  in_check
		end

		def move_piece_alegebraic(start_pos_str, new_pos_str)
			start_pos = to_pos(start_pos_str)
			new_pos = to_pos(new_pos_str)
			return move_piece(start_pos, new_pos)
		end

				# turns the x position from a string to an integer

		def to_pos(pos)
			 		x = pos[0].downcase
			 		y = (pos[1].to_i) - 1
					case x
						when "a"
							x = 0
						when "b"
							x = 1
						when "c"
							x = 2
						when "d"
							x = 3
						when "e"
							x = 4
						when "f"
							x = 5
						when "g"
							x = 6 
						when "h"
							x = 7
					end
					return [x,y]
		end

		#moves the piece, replaces previous position with an empty node and clean the calculate risk for the king

		def move_piece(start_pos, new_pos)
			index_start = index_of(start_pos)
			index_new = index_of(new_pos)
			node =  @nodes[index_start]
			@nodes[index_new] = node
			node.pos = new_pos
			@nodes[index_start] =  Node.new(pos = start_pos, board = self)
			clean_after_moving(start_pos)
			return node.pos
		end

		def clean_after_moving(pos_moved)
			@danger_to_wking = []
			@danger_to_bking = []
			@can_capture_white = nil 
			@can_capture_black = nil 
			remove_edges_with(pos_moved)

		end

		def remove_edges_with(pos)
			@nodes.each do |node|
				if node.class != Node 
					node.delete_neighbour_if_includes(pos)	
				end
			end
		end

		def add_node(node)
			if node_index = index_of(node.pos)
				@nodes[node_index] = node
			else
				@nodes.push(node)
			end
		end

		def remove_node(node_position)
			if node_index = index_of(node_position)
				@nodes.slice!(node_index)
			end
		end


		def node(node_position)
			if node_index = index_of(node_position)
				return @nodes[node_index]
			else 
				nil
			end
		end

		def contains?(node_position)
			if index_of(node_position)
				return true
			else 
				return false
			end
		end

		def index_of(node_position)
			
			@nodes.each_with_index do |node, index|
				if node.pos == node_position
					return index 
				end
			end

			return nil 
		end

		def add_edge(node1_position, node2_position, unidirectional = false)
			index_node1 = index_of(node1_position)
			index_node2 = index_of(node2_position)
			if index_node1 && index_node2
				#saving the node's position assigning in its neighbours instace variable using node's graph index
				@nodes[index_node1].neighbours[index_node2] =  @nodes[index_node2]
				#@nodes[index_node2]
				if unidirectional
					@nodes[index_node2].neighbours[index_node1] =  @nodes[index_node1]
					#@nodes[index_node1]
				end
			end
		end

		def has_edge?(node1_position, node2_position)
			index_node1 = index_of(node1_position)
			@nodes[index_node1].neighbours.include?(node2_position)
		end

		def remove_edge(node1_position, node2_position, unidirectional = false)
			index_node1 = index_of(node1_position)
			index_node2 = index_of(node2_position)
			if index_node1 && index_node2
				@nodes[index_node1].delete_neighbour(index_node2)
				if unidirectional
					@nodes[index_node2].delete_neighbour(index_node1)
				end
			end
		end



		def remove_all_edges
			@nodes.each do |node|
				node.neighbours = []
			end
		end

		def count
			@nodes.length
		end

		#converts recursvile value of a  object hash in primitive values
		def as_json(options ={})
			{
				name: self.class.name,
				nodes: @nodes,

			}
		end

		#converts to a string in json
		def to_json(*options)
			as_json(*options).to_json(*options)
	 	end

end
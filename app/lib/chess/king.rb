require_relative 'piece.rb'
class King < Piece
			 
			def add_edge_to_posible_move(initial_pos,posible_move, blocker)
				if !blocker.include?(posible_move) 
					if safe_move(posible_move)
						node_in_move = @board.node(posible_move)
						if  node_in_move.class == Node
							@board.add_edge(initial_pos, posible_move)

							if @white
								if !@board.danger_to_bking.include?(posible_move)
									@board.danger_to_bking.push(posible_move)
								end
							else

								if !@board.danger_to_wking.include?(posible_move)
									@board.danger_to_wking.push(posible_move)
								end
							end							
						else
							if @white
								if node_in_move.white 
									if !@board.danger_to_bking.include?(posible_move)
										@board.danger_to_bking.push(posible_move)
									end
								elsif !node_in_move.white
									@board.add_edge(initial_pos, posible_move)
								end
							else
								if !node_in_move.white 
									if !@board.danger_to_wking.include?(posible_move)
										@board.danger_to_wking.push(posible_move)
									end
								elsif node_in_move.white
									@board.add_edge(initial_pos, posible_move)
								end
							end
						end
					end
				end
			end			 

			def calculate_posible_moves( blocker = [], limited_moves = [], ignore =[] )
				@neighbours = []
			 	initial_pos = @pos.dup

			 	#right up
			 	if initial_pos[0] + 1 <= 7 && initial_pos[1] + 1  <= 7
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] + 1 ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker)
			 	end

			 	#right down
			 	if initial_pos[0] + 1 <= 7 && initial_pos[1] - 1  >= 0
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] - 1 ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker)
			 	end

			 	#left up
			 	if initial_pos[0] - 1 >= 0 && initial_pos[1] + 1  <= 7
			 		posible_move =[initial_pos[0] - 1 , initial_pos[1] + 1 ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker )
			 	end

			 	#left down
			 	if initial_pos[0] - 1 >= 0 && initial_pos[1] - 1  >= 0
			 		posible_move =[initial_pos[0] - 1 , initial_pos[1] -1 ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker )
			 	end

			 	#right
			 	if initial_pos[0] + 1 <= 7 
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker)
			 	end

			 	#left
			 	if initial_pos[0] - 1 >= 0
			 		posible_move =[initial_pos[0] - 1 , initial_pos[1] ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker)
			 	end

			 	#up
			 	if initial_pos[1] + 1 <= 7 
			 		posible_move =[initial_pos[0] , initial_pos[1] + 1]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker)
			 	end

			 	#down
			 	if initial_pos[1] - 1  >= 0 
			 		posible_move =[initial_pos[0], initial_pos[1] - 1 ]
			 		add_edge_to_posible_move(initial_pos,posible_move, blocker)
			 	end

			 	return "ready"
			end

		   def safe_move(pos)

				@board.nodes.each do |node|
					if @white
						if (node.class == Queen || node.class == Bishop || node.class == Rook ) && !node.white
							if node.neighbours_includes?(@pos)
								original_neighbours = node.neighbours.dup
								node.calculate_posible_moves([], [], @pos)
								if node.neighbours_includes?(pos)
									node.neighbours = original_neighbours
									return false
								else
									node.neighbours = original_neighbours
								end
							end
						elsif !node.class == Node && !node.white
							node.neighbours_includes?(pos)
						end
					else
						if (node.class == Queen || node.class == Bishop || node.class == Rook ) && node.white
							if node.neighbours_includes?(@pos)
								original_neighbours = node.neighbours.dup
								node.calculate_posible_moves( [], [], @pos)
								if node.neighbours_includes?(pos)
									node.neighbours = original_neighbours
									return false
								else
									node.neighbours = original_neighbours
								end
							end	
						elsif !node.class == Node && node.white
							node.neighbours_includes?(pos)											
						end
					end
				end

				return true
		    end
end
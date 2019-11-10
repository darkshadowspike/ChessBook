require_relative 'piece.rb'
class Pawn < Piece
			def add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, diagonal = false)
			
				unless (limited_moves.any? && !limited_moves.include?(posible_move) ) || !safe_move(posible_move)

					node_in_move = @board.node(posible_move)
					unless diagonal
						if node_in_move.class == Node 
							@board.add_edge(initial_pos, posible_move)
						end
					else	

						if @white

							if node_in_move.class != Node && !node_in_move.white 
									@board.add_edge(initial_pos, posible_move)
							else
								if !@board.danger_to_bking.include?(posible_move)
									@board.danger_to_bking.push(posible_move)
								end 
							end							

						else
								
							if  node_in_move.class != Node && node_in_move.white 
								@board.add_edge(initial_pos, posible_move)
							else
								if !@board.danger_to_wking.include?(posible_move)
									@board.danger_to_wking.push(posible_move)
								end
							end

						end

					end
				end
			end

			# checks to what nodes this piece could posibly move, and creates a edge undirectional edge for to nodes
			def calculate_posible_moves( blocker = [], limited_moves = [], ignore =[] )

				@neighbours = []
				initial_pos = @pos.dup
				
				if @white

					# go up  as white
					if initial_pos[1] + 1 <= 7
						posible_move = [initial_pos[0],initial_pos[1]+1]
						add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)

					end

					#eats rightup as white
					if initial_pos[0] + 1 <= 7 && initial_pos[1] + 1 <= 7 
						posible_move = [initial_pos[0]+1,initial_pos[1]+1]
						add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, true)
					end

					#eats leftup as white
					if initial_pos[0] - 1 >= 0 && initial_pos[1] + 1 <= 7 
						posible_move = [initial_pos[0]-1,initial_pos[1]+1]
						add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, true)
					end
				else

					if initial_pos[1] - 1 >= 0
						posible_move = [initial_pos[0],initial_pos[1]-1]
						add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
					end

					if initial_pos[0] + 1 <= 7 && initial_pos[1] - 1 >= 0 
						posible_move = [initial_pos[0]+1,initial_pos[1]-1]
						add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore,true)
					end

					if initial_pos[0] - 1 >= 0 && initial_pos[1] - 1 >= 0 
						posible_move = [initial_pos[0]-1,initial_pos[1]-1]
						add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, true)
					end


				end

				return "ready"
			end

end
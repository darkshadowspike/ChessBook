require_relative 'piece.rb'
class Knight < Piece
			
			def add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				unless (limited_moves.any? && !limited_moves.include?(posible_move) ) || !safe_move(posible_move)
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


			def calculate_posible_moves( blocker = [], limited_moves = [], ignore =[] )
				@neighbours = []
				initial_pos = @pos.dup

				if initial_pos[0]+1 <= 7 && initial_pos[1]+2 <= 7
					posible_move = [initial_pos[0]+ 1, initial_pos[1]+2]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]+1 <= 7 && initial_pos[1]-2 >= 0
					posible_move = [initial_pos[0]+ 1, initial_pos[1]-2]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]-1 >= 0 && initial_pos[1]+2 <= 7
					posible_move = [initial_pos[0]- 1, initial_pos[1]+2]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]-1 >= 0 && initial_pos[1]-2 >= 0
					posible_move = [initial_pos[0]- 1, initial_pos[1]-2]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]+2 <= 7 && initial_pos[1]+1 <= 7
					posible_move = [initial_pos[0]+ 2, initial_pos[1]+1]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]+2 <= 7 && initial_pos[1]-1 >= 0
					posible_move = [initial_pos[0]+ 2, initial_pos[1]-1]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]-2 >= 0 && initial_pos[1]+1 <= 7
					posible_move = [initial_pos[0]- 2, initial_pos[1]+1]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				if initial_pos[0]-2 >= 0 && initial_pos[1]-1 >= 0
					posible_move = [initial_pos[0]- 2, initial_pos[1]-1]
					add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore)
				end

				return "ready"
			end
end
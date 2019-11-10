require_relative 'piece.rb'
class Bishop < Piece
	
			def add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore,  is_not_enemy_safe_check)

				unless (limited_moves.any? && !limited_moves.include?(posible_move) ) || ( is_not_enemy_safe_check && !safe_move(posible_move) )
						node_in_move = @board.node(posible_move)
						if node_in_move.class == Node || posible_move == ignore
							if @white
								if !@board.danger_to_bking.include?(posible_move) && is_not_enemy_safe_check
									@board.danger_to_bking.push(posible_move)
								end 
							else
								if !@board.danger_to_wking.include?(posible_move) && is_not_enemy_safe_check
									@board.danger_to_wking.push(posible_move)
								end
							end
							@board.add_edge(initial_pos, posible_move)
							if blocker == posible_move
								return false
							else
								return true
							end
						else
							if @white

								if !node_in_move.white 
									@board.add_edge(initial_pos, posible_move)
									return false
								elsif node_in_move.white 														
								if !@board.danger_to_bking.include?(posible_move) && is_not_enemy_safe_check
									@board.danger_to_bking.push(posible_move)
								end 
									return false 	
								end

							else

								if node_in_move.white
									@board.add_edge(initial_pos, posible_move)
									return false
								elsif !node_in_move.white 
								if !@board.danger_to_wking.include?(posible_move) && is_not_enemy_safe_check
									@board.danger_to_wking.push(posible_move)
								end
									return false 	

								end

							end
						end 
				else 
					if node_in_move.class == Node || posible_move == ignore
						return true
					else
						return false
					end
				end
			end


			def calculate_posible_moves( blocker = [], limited_moves = [], ignore =[], is_not_enemy_safe_check = true )
				@neighbours = []
				initial_pos = @pos.dup
				moves_limit = false
				i = 1

				# rightup 
				until moves_limit do 
					if initial_pos[0] + i <= 7 && initial_pos[1] + i <= 7
						posible_move =[initial_pos[0] + i, initial_pos[1] + i]
							
						if !add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, is_not_enemy_safe_check)
							moves_limit = true
							break
						end	
						
					else
						moves_limit = true
					end
					i +=1
				end

				#leftup

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] - i >= 0 && initial_pos[1] + i <= 7
						posible_move =[initial_pos[0] - i , initial_pos[1] + i]

						if !add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, is_not_enemy_safe_check)
							moves_limit = true
							break
						end	

					else
						moves_limit = true
					end
					i+=1
				end

				# right down

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] + i <= 7 && initial_pos[1] - i >= 0
						posible_move =[initial_pos[0] + i , initial_pos[1] - i]

						if !add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, is_not_enemy_safe_check)
							moves_limit = true
							break
						end	

					else
						moves_limit = true
					end
					i+=1
				end


				# leftdown

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] - i >= 0 && initial_pos[1] - i >= 0
						posible_move =[initial_pos[0] - i , initial_pos[1] - i]

						if !add_edge_to_posible_move(initial_pos, posible_move, blocker, limited_moves,ignore, is_not_enemy_safe_check)
							moves_limit = true
							break
						end	

					else
						moves_limit = true
					end
					i+=1
				end
				return "ready"
			end
end
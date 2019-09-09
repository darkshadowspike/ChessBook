module Chess
	include GraphBase
	module Pieces
		#Class pieces to be used bye the Board and game

		#Basepiece 
		class Piece
			attr_accessor :pos, :table_graph , :symbol, :white
			
			def initialize(pos=[1,1], symbol ="", white = true )
				#pos = [X,Y]
				@pos = pos
				@symbol = symbol
				@white = white
				@table_graph = table_graph_create

			end

			#creates a graph in the of a chess table [8x8] using Graph class

			def table_graph_create
				graph = GraphBase::Graph.new
				x = 1
				while x <= 8
					y = 1 
					while y <= 8
						graph.add_node([x,y])
						y +=1
					end
				x+=1
				end
				return graph
			end

			#returns the position in form of a string

			def string 
				spos = @pos.dup
				case spos[0]
					when 1
                		spos[0]="A"
             		when 2
                		spos[0]="B"
            		when 3
               			spos[0]="C"
             		when 4
                		spos[0]="D"
             		when 5
                		spos[0]="E"
             		when 6
                		spos[0]="F"
             		when 7
                		spos[0]="G"
             		when 8
                		spos[0]="H"
             	end
       			return spos[0]+spos[1].to_s
			end

			# turns a x position in string to an integer

			def to_pos(str)
				x = str.downcase
				case x
					when "a"
						x = 1
					when "b"
						x = 2
					when "c"
						x = 3
					when "d"
						x = 4
					when "e"
						x = 5
					when "f"
						x = 6
					when "g"
						x = 7 
					when "h"
						x = 8
				end
				return x
			end

			# methods for easy serialization using JSON

			def as_json(options={})

			        {
			            jclass: self.class.name,
			            data: {
			               pos: pos,
			               table_graph: table_graph,
			               symbol: symbol,
			               white: white
			            }
			        }
		    end

  			def to_json(*options)
        		as_json(*options).to_json(*options)
 			end


     
		end

		class Pawn < Piece

			def posible_moves(allies = [], enemies = [], king_check = false, prohibited_moves =[])
				#allies is an array with the position of same color pieces
				#enemies is an array with the position of different color pieces
				#kingcheck for when the king has to move check for dangerous/self check moves
				#prohibited moves , array or moves that are not allowed

				initial_pos = @pos.dup
				
				if @white

					# go up  as white
					if initial_pos[1] + 1 <= 8
						posible_move = [initial_pos[0],initial_pos[1]+1]
						if !allies.include?(posible_move ) && !enemies.include?(posible_move ) 
							@table_graph.add_edge(initial_pos, posible_move)
						end
					end

					#eats rightup as white
					if initial_pos[0] + 1 <= 8 && initial_pos[1] + 1 <= 8 
						posible_move = [initial_pos[0]+1,initial_pos[1]+1]
						if king_check || enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
						end
					end

					#eats leftup as white
					if initial_pos[0] - 1 >= 1 && initial_pos[1] + 1 <= 8 
						posible_move = [initial_pos[0]-1,initial_pos[1]+1]
						if king_check || enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
						end
					end
				else

					if initial_pos[1] - 1 >= 1
						posible_move = [initial_pos[0],initial_pos[1]-1]
						if !allies.include?(posible_move) && !enemies.include?(posible_move) 
							@table_graph.add_edge(initial_pos, posible_move)
						end
					end

					if initial_pos[0] + 1 <= 8 && initial_pos[1] - 1 >= 1 
						posible_move = [initial_pos[0]+1,initial_pos[1]-1]
						if king_check || enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
						end
					end

					if initial_pos[0] - 1 >= 1 && initial_pos[1] - 1 >= 1 
						posible_move = [initial_pos[0]-1,initial_pos[1]-1]
						if  king_check || enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
						end
					end


				end

				return @table_graph
			end

		end

		class King < Piece
			 
			 def posible_moves(allies = [], enemies = [], king_check = false, prohibited_moves =[])
			 	initial_pos = @pos.dup

			 	#right up
			 	if initial_pos[0] + 1 <= 8 && initial_pos[1] + 1  <= 8
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] + 1 ]
			 		if  king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#right down
			 	if initial_pos[0] + 1 <= 8 && initial_pos[1] - 1  >= 1
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] - 1 ]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#left up
			 	if initial_pos[0] - 1 >= 1 && initial_pos[1] + 1  <= 8
			 		posible_move =[initial_pos[0] - 1 , initial_pos[1] + 1 ]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#left down
			 	if initial_pos[0] - 1 >= 1 && initial_pos[1] - 1  >= 1
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] -1 ]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#right
			 	if initial_pos[0] + 1 <= 8 
			 		posible_move =[initial_pos[0] + 1 , initial_pos[1] ]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#left
			 	if initial_pos[0] - 1 >= 1 
			 		posible_move =[initial_pos[0] - 1 , initial_pos[1] ]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#up
			 	if initial_pos[1] + 1 <= 8 
			 		posible_move =[initial_pos[0] , initial_pos[1] + 1]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	#down
			 	if initial_pos[1] - 1  >= 1 
			 		posible_move =[initial_pos[0], initial_pos[1] - 1 ]
			 		if king_check || (!allies.include?(posible_move) && !prohibited_moves.include?(posible_move))
			 			@table_graph.add_edge(initial_pos, posible_move)
			 		end
			 	end

			 	return @table_graph
			 end
		end

		class Queen < Piece

			def posible_moves(allies = [], enemies = [], king_check = false , prohibited_moves =[])
				initial_pos = @pos.dup
				moves_limit = false
				i = 1

				# rightup 
				until moves_limit do 
					if initial_pos[0] + i <= 8 && initial_pos[1] + i <= 8
						posible_move =[initial_pos[0] + i, initial_pos[1] + i]
							
						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else 
							@table_graph.add_edge(initial_pos, posible_move)
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
					if initial_pos[0] - i >= 1 && initial_pos[1] + i <=8
						posible_move =[initial_pos[0] - i , initial_pos[1] + i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end

				# right down

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] + i <= 8 && initial_pos[1] - i >=1
						posible_move =[initial_pos[0] + i , initial_pos[1] - i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# leftdown

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] - i >= 1 && initial_pos[1] - i >= 1
						posible_move =[initial_pos[0] - i , initial_pos[1] - i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# up

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[1] + i <=8
						posible_move =[initial_pos[0], initial_pos[1] + i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# down

				moves_limit = false
				i = 1

				until moves_limit do 
					if  initial_pos[1] - i >= 1
						posible_move =[initial_pos[0]  , initial_pos[1] - i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# right 

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] + i <= 8 
						posible_move =[initial_pos[0] + i , initial_pos[1]]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# left

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] - i >= 1
						posible_move =[initial_pos[0] - i , initial_pos[1]]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end

				return @table_graph
			end
		end

		class Knight < Piece
			def posible_moves(allies = [], enemies = [], king_check = false , prohibited_moves =[])
				initial_pos = @pos.dup

				if initial_pos[0]+1 <= 8 && initial_pos[1]+2 <=8
					posible_move = [initial_pos[0]+ 1, initial_pos[1]+2]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]+1 <= 8 && initial_pos[1]-2 >=1
					posible_move = [initial_pos[0]+ 1, initial_pos[1]-2]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]-1 >= 8 && initial_pos[1]+2 <= 8
					posible_move = [initial_pos[0]- 1, initial_pos[1]+2]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]-1 >= 8 && initial_pos[1]-2 >= 1
					posible_move = [initial_pos[0]- 1, initial_pos[1]-2]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]+2 <= 8 && initial_pos[1]+1 <= 8
					posible_move = [initial_pos[0]+ 2, initial_pos[1]+1]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]+2 <= 8 && initial_pos[1]-1 >= 1
					posible_move = [initial_pos[0]+ 2, initial_pos[1]-1]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]-2 >= 1 && initial_pos[1]+1 <= 8
					posible_move = [initial_pos[0]- 2, initial_pos[1]+1]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				if initial_pos[0]-2 >= 1 && initial_pos[1]-1 >= 1
					posible_move = [initial_pos[0]- 2, initial_pos[1]-1]
					if king_check || !allies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					elsif enemies.include?(posible_move)
						@table_graph.add_edge(initial_pos, posible_move)
					end
				end

				return @table_graph
			end
		end

		class Rook < Piece

			def posible_moves(allies = [], enemies = [], king_check = false , prohibited_moves =[])
				initial_pos = @pos.dup
				moves_limit = false
				i = 1

				# up

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[1] + i <=8
						posible_move =[initial_pos[0], initial_pos[1] + i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# down

				moves_limit = false
				i = 1

				until moves_limit do 
					if  initial_pos[1] - i >= 1
						posible_move =[initial_pos[0]  , initial_pos[1] - i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# right 

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] + i <= 8 
						posible_move =[initial_pos[0] + i , initial_pos[1]]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# left

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] - i >= 1
						posible_move =[initial_pos[0] - i , initial_pos[1]]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end

				return @table_graph 
			end
		end

		class Bishop < Piece
			def posible_moves(allies = [], enemies = [], king_check = false , prohibited_moves =[])

				initial_pos = @pos.dup
				moves_limit = false
				i = 1

				# rightup 
				until moves_limit do 
					if initial_pos[0] + i <= 8 && initial_pos[1] + i <=8
						posible_move =[initial_pos[0] + i, initial_pos[1] + i]
							
						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else 
							@table_graph.add_edge(initial_pos, posible_move)
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
					if initial_pos[0] - i >= 1 && initial_pos[1] + i <=8
						posible_move =[initial_pos[0] - i , initial_pos[1] + i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end

				# right down

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] + i <= 8 && initial_pos[1] - i >= 1
						posible_move =[initial_pos[0] + i , initial_pos[1] - i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end


				# leftdown

				moves_limit = false
				i = 1

				until moves_limit do 
					if initial_pos[0] - i >= 1 && initial_pos[1] - i >= 1
						posible_move =[initial_pos[0] - i , initial_pos[1] - i]

						if allies.include?(posible_move)
							if king_check
								@table_graph.add_edge(initial_pos, posible_move)
								moves_limit = true
								break
							else
								break
							end
						elsif enemies.include?(posible_move)
							@table_graph.add_edge(initial_pos, posible_move)
							moves_limit = true
							break
						else
							@table_graph.add_edge(initial_pos, posible_move)
						end

					else
						moves_limit = true
					end
				end
			end
		end

	end 
end
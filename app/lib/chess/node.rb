class Node
	attr_accessor :pos, :neighbours, :board

	def initialize(pos=[0,0],board)
			#[X,Y]
        	#pos = [X,Y]
			@pos = pos
			@neighbours = []
			@board = board
	end


	def neighbours_pos 
		pos =[]
		@neighbours.each do |node|
			if node
				pos.push(node.pos)
			end
		end 
		return pos
	end

	def delete_neighbour(n_index)		
		@neighbours.slice!(n_index)
	end

	# methods for easy serialization using JSON

	#converts the value of a object hash in primitive values

	def as_json(options={})

			{
			    name: self.class.name,
			    data: {
			        pos: pos,
			    }
			}
	end

	#converts to a string in json

  	def to_json(*options)
        as_json(*options).to_json(*options)
 	end

 			#turns the x position from an integer to string

	def to_text(single_pos)	
					case single_pos
						when 0
	                		single_pos ="A"
	             		when 1
	                		single_pos ="B"
	            		when 2
	               			single_pos ="C"
	             		when 3
	                		single_pos ="D"
	             		when 4
	                		single_pos ="E"
	             		when 5
	                		single_pos ="F"
	             		when 6
	                		single_pos ="G"
	             		when 7
	                		single_pos ="H"
	             	end
	       			return single_pos
	end		

		# turns the x position from a string to an integer

	def to_pos(single_pos)
			 		x = single_pos.downcase
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
					return x
	end

		#translate to position to match interface /text version

	def text_pos(pos = @pos)	
		return to_text(pos[0]) + (pos[1] + 1).to_s
	end
	
end
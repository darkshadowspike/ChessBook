module GraphBase
	#class to make the instance of the nodes
	class Vertice
		attr_accessor :position , :neighbours

		def initialize(position)
			@position = position 
			@neighbours = []
		end

		def neighbour_index?(neighbour_position)
			@neighbours.each_with_index do |node, index|
				if node
					if node.position  == neighbour_position
						return index
					end
				end
			end
			return nil
		end

		def delete_neighbour(neighbour_position)
			if n_index = neighbour_index?(neighbour_position)
				@neighbours.slice!(n_index)
			end
		end


	end

	#Graph class uses instace of vertices for its nodes
	class Graph
		attr_accessor :nodes

		def initialize
			@nodes = []
		end

		def node(node_position)
			if node_index = index_of(node_position)
				return @nodes[node_index]
			else 
				nil
			end
		end

		def add_node(node_position)
			@nodes.push(Vertice.new(node_position))
		end

		def remove_node(node_position)
			if node_index = index_of(node_position)
				@nodes.slice!(node_index)
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
				if node.position == node_position
					return index 
				end
			end

			return nil 
		end

		def add_edge(node1_position, node2_position, unidirectional = true)
			index_node1 = index_of(node1_position)
			index_node2 = index_of(node2_position)
			if index_node1 && index_node2
				#saving the node's position assigning in its neighbours instace variable using node's graph index
				@nodes[index_node1].neighbours[index_node2] =  @nodes[index_node2]
				if unidirectional
					@nodes[index_node2].neighbours[index_node1] =  @nodes[index_node1]
				end
			end
		end

		def has_edge?(node1_position, node2_position)
			index_node1 = index_of(node1_position)
			if @nodes[index_node1].neighbour_index?(node2_position)
				return true
			else 
				return false
			end
		end

		def remove_edge(node1_position, node2_position, unidirectional = true)
			index_node1 = index_of(node1_position)
			index_node2 = index_of(node2_position)
			if index_node1 && index_node2
				@nodes[index_node1].delete_neighbour(index_node2)
				if unidirectional
					@nodes[index_node2].delete_neighbour(index_node1)
				end
			end
		end

		def count
			@nodes.length
		end

	end
	
end
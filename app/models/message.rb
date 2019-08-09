class Message < ApplicationRecord
	
	#using a lambda with default scope to retrive in descendent order
 	default_scope -> { order(created_at: :desc)}

	# requester id
	belongs_to :sender, class_name: "User"
	# receiver id
	belongs_to :receiver, class_name: "User"
	
	validates :receiver_id, :sender_id, :content, presence: true

	def from_user?(user)
		if user.id == sender_id
			return true
		else 
			return false
		end
	end

end

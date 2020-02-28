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

	def read
		unless viewed?
			update_attributes(viewed: true)
		end
	end

	def self.messages_between_users(first_user, other_user)
		return Message.where("(sender_id = :user_id AND receiver_id = :other_user_id) OR (sender_id = :other_user_id AND receiver_id = :user_id) ", user_id: first_user.id, other_user_id: other_user.id)
	end

	def self.user_new_messages(user, new_only = true)
		if new_only
			messages_query = "receiver_id = :user_id AND viewed = 0"
		else
			messages_query = "receiver_id = :user_id"
		end
		return Message.where("#{messages_query}",user_id: user.id).group(:sender_id).includes(:sender)
	end

	def self.read_all(user_id, sender_id)
		Message.where("receiver_id = :user_id AND sender_id = :sender_id AND viewed = 0",user_id: user_id, sender_id: sender_id).update_all(viewed: true)
	end

end

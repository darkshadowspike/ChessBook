class Relationship < ApplicationRecord
	# requester id
	belongs_to :friend_active, class_name: "User"
	# receiver id
	belongs_to :friend_pasive, class_name: "User"
	
	validates :friend_active_id, :friend_pasive_id, presence: true
end

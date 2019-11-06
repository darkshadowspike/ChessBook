class Relationship < ApplicationRecord
	
	# sender id
	belongs_to :friend_active, class_name: "User"
	# receiver id
	belongs_to :friend_pasive, class_name: "User"
	
	validates :friend_active_id, :friend_pasive_id, presence: true

	def self.friendship(user1_id, user2_id )

		return Relationship.where("(friend_active_id = :user_id AND friend_pasive_id = :other_user_id) OR (friend_active_id = :other_user_id AND friend_pasive_id = :user_id)",user_id: user1_id, other_user_id: user2_id )[0]

	end

end

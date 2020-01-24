class Relationship < ApplicationRecord

	# sender id
	belongs_to :friend_active, class_name: "User"
	# receiver id
	belongs_to :friend_pasive, class_name: "User"
	
	validates :friend_active_id, :friend_pasive_id, presence: true

	def self.friendship(user1_id, user2_id )
		return Relationship.where("(friend_active_id = :user_id AND friend_pasive_id = :other_user_id) OR (friend_active_id = :other_user_id AND friend_pasive_id = :user_id)",user_id: user1_id, other_user_id: user2_id )[0]
	end

	def self.post_created(user)
		active_relations = Relationship.where("friend_active_id = :user_id",user_id: user.id)
		pasive_relations = Relationship.where("friend_pasive_id = :user_id",user_id: user.id)
		if active_relations.any?
			active_relations.update_all("friend_active_new_posts = friend_active_new_posts + 1")
		end
		if pasive_relations.any?
			pasive_relations.update_all("friend_pasive_new_posts = friend_pasive_new_posts + 1")
		end

	end

	def self.friends_with_new_posts(user)
		return Relationship.where("(friend_active_id = :user_id AND friend_pasive_new_posts >= 2) OR (friend_pasive_id = :user_id AND friend_active_new_posts >= 2)",user_id: user.id).includes(:friend_pasive, :friend_active)
	end

	def watched_posts_from_user(user2)
		
		if friend_pasive_id = user2.id
			update_attributes(friend_pasive_new_posts: 0)
		else
			update_attributes(friend_active_new_posts: 0)
		end
	end

	def self.watch_all_the_post_from_user(user)
		active_relations = Relationship.where("friend_active_id = :user_id",user_id: user.id)
		pasive_relations = Relationship.where("friend_pasive_id = :user_id",user_id: user.id)
		if active_relations.any?
			active_relations.update_all("friend_pasive_new_posts = 0")
		end
		if pasive_relations.any?
			pasive_relations.update_all("friend_active_new_posts = 0")
		end
	end

end

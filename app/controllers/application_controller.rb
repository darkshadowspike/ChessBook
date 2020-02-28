class ApplicationController < ActionController::Base
	#using rails method to protect against cross request forgery attacks raising and exception 
	protect_from_forgery with: :exception

	#include Sessions helper module to give their methods to all controllers
	include SessionsHelper

	#include pagy  gem for pagination
	include Pagy::Backend

	private

	#confirms that users is logged with sessions helper logged_in? method and saves its location with store_location and redirects to login url

	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "Log in"
			redirect_to login_url
		end
	end

	def set_friends
		if current_user
			@friends = current_user.friends_ordered_by_latest_messaged
			unless @friends.any?
				@friends = current_user.friends
			end 
		end
	end

	def set_user
		if current_user
			@user = current_user
		end
	end

	def check_new_content
		if current_user

			@relationships_new_posts = Relationship.friends_with_new_posts(current_user)
			@new_messages = Message.user_new_messages(current_user)
			@new_requests = current_user.friend_new_requests
			@new_chessgame_moves = Chessgame.check_games_with_new_player_moves(current_user)
		end
	end
end

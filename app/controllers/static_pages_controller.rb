class StaticPagesController < ApplicationController

	def home
		if logged_in?
			@user = current_user
			@post = current_user.posts.build
			@posts = @user.posts.all
		else
			@user = User.new
			@title ="log in or sign up"
		end
	end

end

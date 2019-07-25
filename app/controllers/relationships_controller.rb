class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:friend_pasive_id])
		current_user.friend_request(@user)
		respond_to do |format|
				format.html {redirect_to @user}
				format.js
		end
	end

	def update
		@user = Relationship.find(params[:id]).friend_active
		current_user.accept_request(@user)
		respond_to do |format|
				format.html {redirect_to @user}
				format.js
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		current_user.delete_friend(@user)
		respond_to do |format|
				format.html {redirect_to @user}
				format.js
		end
	end

end

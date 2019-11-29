class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :gamechat]
	before_action :correct_user, only: [:edit, :update]
	before_action :is_admin, only: [:index, :destroy]
	before_action :set_friends, only: [:home, :gamechat, :show, :checkup]

	def home
		if logged_in?

			@user = current_user
			@post = current_user.posts.build
			@pagy, @posts = pagy(@user.user_feed, page: params[:page] ,items: 8, link_extra: 'data-remote="true"')
			respond_to do |format|
				format.html 
				format.js
			end
		else
			@user = User.new
			@title ="log in or sign up"
		end
	end

	def index
		@pagy, @users = pagy(User.all, page: params[:page], items: 10)
	end

	def checkup
		if logged_in?
			current_user.connect
		end
		respond_to do |format|
				format.html 
				format.js
		end
	end

	def gamechat	
		@message = current_user.sended_messages.build
		unless params[:friend_id]
			@friend = @friends[0]
		else
			@friend = User.find(params[:friend_id].to_i)
		end
		if @friend
			@relationship = Relationship.friendship(current_user.id, @friend.id)
			@pagy, @messages = pagy(current_user.messages_with_user(@friend ),   page: params[:page] ,  items: 8, link_extra: 'data-remote="true"')
			@chessgame = current_user.game_with_user(@friend)
			if  @chessgame
				@chessgame.load_board
			else
				@chessgame = current_user.game_as_player1.create(player2_id: @friend.id)
			end
		end
		
		respond_to do |format|
				format.html 
				format.js
		end
	end

	def show

		@user =User.find(params[:id])
		@pagy, @posts = pagy(@user.posts.all, page: params[:page] ,items: 8, link_extra: 'data-remote="true"')
		if logged_in?
			@post = current_user.posts.build
		end
		
		respond_to do |format|
				format.html 
				format.js
		end
	end

	def new
		@user = User.new
	end

	def create
		@user= User.new(user_params)
		@user.avatar.attach(io: File.open('app/assets/images/default_profile_pic.png'), filename: "default_profile_pic.png")
		@user.mural.attach(io: File.open('app/assets/images/default_profile_mural.jpg'), filename: "default_profile_mural.jpg")
		if @user.save
			@user.send_activation_email
			render "activation"
		else
			render "new"
		end
	end

	def edit
		@user =User.find(params[:id])
	end

	def update 
		@user =User.find(params[:id])
		if @user.update_attributes(user_params)
			redirect_to user_url(@user)
		else
			render "edit"
		end
	end

	def destroy
		@user =User.find(params[:id])
		@user.destroy
		flash[:sucess] = "user deleted"
		redirect_to root_url
	end

	private

	#check the paramaters and only passes permited  ones
	def user_params
		params.require(:user).permit(:first_name, :last_name, :user_name, :email , :birthday, :gender, :password, :avatar, :mural)
	end

	def correct_user
		@user = User.find(params[:id])
		unless current_user?(@user)
			redirect_to root_url
		end
	end 

	def is_admin
		unless current_user.admin?
			redirect_to root_url
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

end

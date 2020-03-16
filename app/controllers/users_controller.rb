class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :destroy, :gamechat]
	before_action :correct_user, only: [:edit, :update]
	before_action :is_admin, only: [:destroy]
	before_action :set_friends, only: [:home, :gamechat, :show, :checkup, :index, :edit]
	before_action :set_user, only: [:home, :gamechat, :checkup, :index]
	before_action :check_new_content, only: [:home, :gamechat,:show,  :checkup, :index, :edit, :update]

	def home
		if logged_in?
			Relationship.watch_all_the_post_from_user(current_user)
			@relationships_new_posts = []
			@post = current_user.posts.build
			@comment = current_user.comments.build
			@pagy, @posts = pagy(Post.user_feed(@user), page: params[:page] ,items: 8, link_extra: 'data-remote="true"')
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
		@friends_of = params[:friends_of_user]
		@search = params[:search]
		if !@search  && !@friends_of
			if logged_in?
				@new_requests =[]
				@requests = current_user.friend_requests
				@pagy, @users = pagy( current_user.friends_suggestion(false), page: params[:page], items: 10,link_extra: 'data-remote="true"')
				# adds the friends of friends if there isn't a page num params for pagy	
				unless params[:page]				
					@users = current_user.friends_suggestion(true) + @users
				end 

			else
				@pagy, @users = pagy(User.all, page: params[:page], items: 10, items: 10,link_extra: 'data-remote="true"')
			end
		elsif @friends_of
			@user = User.find(@friends_of.to_i)
			@pagy, @users = pagy(@user.friends , page: params[:page], items: 10,link_extra: 'data-remote="true"')
		else
			if logged_in?
				@pagy, @users = pagy(User.where("user_name LIKE '%#{@search}%' AND id != '#{current_user.id}' ") , page: params[:page], items: 10,link_extra: 'data-remote="true"')
			else
				@pagy, @users = pagy(User.where("user_name LIKE '%#{@search}%'") , page: params[:page], items: 10,link_extra: 'data-remote="true"')
			end	
		end
		respond_to do |format|
				format.html 
				format.js
		end
	end


	def checkup
		#debugger
		if logged_in?
			current_user.connect
			@gamechat = user_params[:in_gamechat].to_i
			if  @gamechat == 1
				Message.read_all(current_user.id, user_params[:message_sender_id].to_i )
				@game = Chessgame.game_between_users(current_user.id, user_params[:message_sender_id].to_i, true)
				@game.viewing_game
			end
		end
		respond_to do |format|
				format.html 
				format.js
		end
	end

	def navbar_entries
		@get_posts = user_params[:get_posts]
		@gamechat =  user_params[:in_gamechat].to_i
		@get_messages = user_params[:get_messages]
		@get_requests = user_params[:get_requests]

		if @get_posts && @get_posts == "1"
			@relationships_new_posts = []
		elsif @get_messages && @get_messages =="1"
			@new_chessgame_moves = Chessgame.check_games_with_new_player_moves(current_user)
			@pagy, @new_messages = pagy(Message.user_new_messages(current_user, false) , page: 1 ,items: 5)
		elsif @get_requests && @get_requests == "1"
			@pagy , @new_requests = pagy(current_user.friend_requests , page: 1 ,items: 5)
			if !@new_requests.any?
				@pagy, @new_requests = pagy(current_user.friends_suggestion(true) , page: 1 ,items: 5)
				if !@new_requests.any?
				 	@pagy, @new_requests = pagy(current_user.friends_suggestion(false) , page: 1 ,items: 5)
				end	
			end
		end
		respond_to do |format|
				format.html 
				format.js
		end
	end

	def gamechat
		@gamechat = 1
		@message = current_user.sended_messages.build
		unless params[:friend_id]
			@friend = @friends[0]
		else
			@friend = User.find(params[:friend_id].to_i)
		end
		if @friend
			@relationship = Relationship.friendship(current_user.id, @friend.id)
			@pagy, @messages = pagy(Message.messages_between_users(current_user,@friend ),   page: params[:page] ,  items: 20, link_extra: 'data-remote="true"')
			@chessgame = Chessgame.game_between_users(current_user,@friend)
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
		@photos_only = params[:photos_only]
		@user =User.find(params[:id])

		if logged_in?
			@post = current_user.posts.build
			@comment = current_user.comments.build
			@relationship = Relationship.friendship(current_user.id, @user.id)
			if @relationship
				@relationship.watched_posts_from_user(@user)
			end
		end
		if @photos_only
			@pagy, @posts = pagy(Post.photo_only(@user), page: params[:page] ,items: 8, link_extra: 'data-remote="true"')
		else
			@pagy, @posts = pagy(@user.posts.all, page: params[:page] ,items: 8, link_extra: 'data-remote="true"')
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
		@user.avatar.attach(io: File.open('./public/default_profile_pic.png'), filename: "default_profile_pic.png")
		@user.mural.attach(io: File.open('./public/default_profile_mural.jpg'), filename: "default_profile_mural.jpg")
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
		if user_params
			@user =User.find(params[:id])
			if @user.update_attributes(user_params)
				redirect_to user_url(@user)
			else
				render "edit"
			end
		end
	end

	def destroy
		@user =User.find(params[:id])
		@user.destroy
		flash[:success] = "user deleted"
		redirect_to root_url
	end

	private

	#check the paramaters and only passes permited  ones
	def user_params
		if params[:user]!= nil
			params.require(:user).permit(:first_name, :last_name, :user_name, :email , :birthday, :gender, :password, :avatar, :mural, :get_messages, :get_posts, :get_requests, :in_gamechat, :message_sender_id)
		else
			@user = User.find(params[:id])
			flash[:danger] = "empty form or values" 
			redirect_to edit_user_url(@user)
			return false
		end
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

end

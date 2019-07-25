class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
	before_action :correct_user, only: [:edit, :update]
	before_action :is_admin, only: [:index, :destroy]

	def home
		if logged_in?
			@user = current_user
			@post = current_user.posts.build
			@pagy, @posts = pagy(@user.user_feed, page: params[:page] ,items: 7, link_extra: 'data-remote="true"')
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

	def games
	end

	def show
		@user =User.find(params[:id])
		@pagy, @posts = pagy(@user.posts.all, page: params[:page] ,items: 7, link_extra: 'data-remote="true"')
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
		params.require(:user).permit(:first_name, :last_name, :user_name, :email , :birthday, :gender, :password)
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

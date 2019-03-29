class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
	before_action :correct_user, only: [:edit, :update]

	def index
	end

	def games
	end

	def show
		@user =User.find(params[:id])
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

end

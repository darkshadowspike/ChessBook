class PasswordResetController < ApplicationController
	before_action :get_user, only:[:edit, :update]
	before_action :valid_user, only:[:edit, :update]
	before_action :check_expiration, only:[:edit, :update]

	def new
		@user = User.new
	end

	def create
		@user = User.find_by(email: params[:password_reset][:email].downcase)
		if @user
			@user.create_reset_hash
			@user.send_reset_email
			flash[:info] = "email sent"
			redirect_to root_url
		else
			flash[:danger] = "invalid email"
			redirect_to root_url
		end
	end

	def edit
	end

	def update
		
		if params[:user][:password].empty?
			flash.now[:danger] = "can't be empy"
			render "edit"

		elsif @user.update_attributes(user_params)
			log_in @user
			flash[:sucess] = "new password saved"
			redirect_to user_url(@user)
		else
			#flash to be removed once form specific errors are implemented
			flash.now[:danger] = "invalid password" 
			render "edit"
		end
	end


	private

	def user_params
		params.require(:user).permit(:password)
	end

	def get_user
		@user = User.find_by(email: params[:email])
	end

	def valid_user
		unless (@user && @user.activated? && @user.authentic?(:reset, params[:id]) )
			flash[:danger] = " invalid user"
			redirect_to root_url
		end
	end

	def check_expiration
		unless @user.reset_expired?
			flash[:danger] = "password reset expired"
			redirect_to root_url
		end
	end

end

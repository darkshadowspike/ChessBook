class SessionsController < ApplicationController
	
	def new
		if logged_in?
			redirect_to root_url
		end
	end

	def create
		@user = User.find_by(email: params[:session][:email])
		#athenticates if  password is the same using byicrypt authenticate method
		if @user && @user.authenticate(params[:session][:password])
			if @user.activated
				#if remember is checked  it will asaign the user id to permanent cookies else it will forget
				params[:session][:remember] == "1" ? remember(@user) :  forget(@user)
				login(@user)
				redirect_to root_url
			else
				@message = "Account not activated"
          		@message += "Check your email for the activation link"
          		render "new"
			end
		else
			@message = "Wrong email or password"
		 	render "new"
		end
		
	end

	def destroy
		if logged_in?
			log_out
		end
		redirect_to root_url
	end
end

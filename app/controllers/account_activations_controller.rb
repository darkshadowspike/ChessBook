class AccountActivationsController < ApplicationController
	
	def edit
		if !current_user
			@user = User.find_by(email: params[:email])
			if @user && !@user.activated? && @user.authentic?("activation", params[:id])
				@user.activation
			end
		else 
			redirect_to root_url
		end
	end

end

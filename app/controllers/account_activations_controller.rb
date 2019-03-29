class AccountActivationsController < ApplicationController
	
	def edit
		@user = User.find_by(email: params[:email])
		if @user && !@user.activated? && @user.authentic?("activation", params[:id])
			@user.activation
		end
	end

end

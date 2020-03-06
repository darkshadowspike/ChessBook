class UserMailer < ApplicationMailer
	default from: "testnonreply@gmail.com"

	def account_activation(user)
		@user = user 
		mail to: user.email, subject: "Account activation"
	end

	def reset_password(user)
		@user = user 
		mail to: user.email, subject: "Password reset"
	end

end

module SessionsHelper

	#assigns user ID to rails cookies session
	def login(user)
		session[:user_id] = user.id
	end

	def current_user?(user)
		current_user == user
	end

	#assign the current session's useer 
	def current_user
		#checks if session id cookie is nil
		if session[:user_id]
			# if it isnt it assigns the user to the instace variable current user if it doesn't have a value
			@current_user||= User.find_by(id: session[:user_id])
		#checks out if permanent cookies id is nil 
		elsif cookies.signed[:user_id]
			#if not it finds the user by that id
			user = User.find_by(id: cookies.signed[:user_id])
			#checks if the user is nil and uses the user method authentic? to compare the cookie remember_token to the remember_digest
			if user && user.authentic?(:remember, cookies[:remember_token])
				#if user is not nil and  the permanent cookie match the token it creates a new session based
				login(user)
				#and it assigns the current user
				@current_user||= user
			end
		end
	end

	#checks if the user is logged in checking if the current_user is nil

	def logged_in?
		!current_user.nil?
	end

	#uses user method to create a token to compare it with rail permanent cookies
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	#deletes permanent cookies and assigns nil to the remember token
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	#deletes temporal session cookies and permanent cookies alike
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	#redirects to stored location or to default and deletes session cooki with previous url

	def redirect_back_or(default)
		redirect_to(session[:previous_url] || default )
		session.delete(:previous_url)
	end

	#uses rails controllers request object
    #if request get? method returns true , saves original url in a rails session cookie

	def store_location
		if request.get?
			cookies[:previous_url] = request.url
		end
	end
end

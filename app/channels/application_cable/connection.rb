module ApplicationCable
  class Connection < ActionCable::Connection::Base

 	identified_by :current_user

 	def connect
 		self.current_user = find_verified_user
 	end

 	private

 		def find_verified_user
	  		#recycled code from sessions helper
	  		#checks if cookie id is nil
			if  verified_user = User.find_by(id: cookies.encrypted[:user_id])
				#if it isn't it returns the user
				verified_user
			#checks out if permanent cookies id is nil 
			elsif cookies.signed[:user_id]
				#if not it finds the user by that id
				user = User.find_by(id: cookies.signed[:user_id])
				#checks if the user is nil and uses the user method authentic? to compare the cookie remember_token to the remember_digest
				if user && user.authentic?(:remember, cookies[:remember_token])
					#if user is not nil and  the permanent cookie match the token it creates a new session based
					login(user)
					#and it assigns the verified user
					verified_user||= user
				end
			else 
				reject_unauthorized_connection
			end
  		end

  end
end

class ApplicationController < ActionController::Base
	#using rails method to protect against cross request forgery attacks raising and exception 
	protect_from_forgery with: :exception

	#include Sessions helper module to give their methods to all controllers
	include SessionsHelper

	#include pagy  gem for pagination
	include Pagy::Backend

	private

	#confirms that users is logged with sessions helper logged_in? method and saves its location with store_location and redirects to login url

	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "Log in"
			redirect_to login_url
		end
	end
end

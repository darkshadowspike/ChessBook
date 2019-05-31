class PostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :edit , :update, :destroy]
	
	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			# use ajax to display post or warning using javascript
		else

		end

	end

	def edit
		#use ajax
	end

	def update
		#use ajax
	end

	def destroy 
		#use ajax
	end

	private  

	 def post_params
	 	params.require(:post).permit(:content)
	 end
end

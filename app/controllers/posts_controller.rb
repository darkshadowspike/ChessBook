class PostsController < ApplicationController
	before_action :logged_in_user, only: [  :edit , :update, :destroy]
	before_action :correct_user, only: [ :edit, :update, :destroy]

	
	
	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			# use ajax to display post or warning using javascript
			respond_to do |format|
				format.html {redirect_to request.referrer || root_url}
				format.js
			end
		else
			flash.now[:danger] = "error post couldn't be created"
		end

	end

	def edit
		#use ajax
		@title ="Edit post"
		respond_to do |format|
			format.html 
			format.js
		end
	end

	def update
		#use ajax
		if @post.update_attributes(post_params)
			respond_to do |format|
				format.html { redirect_to  root_url}
				format.js
			end
		else 
			flash[:danger] = "error in post edition"
			respond_to do |format|
				format.html { redirect_to  edit_post_url(@post)}
				format.js
			end
		end
	end

	def destroy 
		@post.destroy
		flash[:success] = "Post deleted"
		respond_to do |format|
			format.html {redirect_to request.referrer || root_url}		
			format.js
		end
	
	end

	private  

	 def post_params
	 	params.require(:post).permit(:content, :media)
	 end

	 def correct_user
	 	@post = current_user.posts.find(params[:id])
	 	unless @post
	 	 	redirect_to root_url
	 	end 
	 end
end

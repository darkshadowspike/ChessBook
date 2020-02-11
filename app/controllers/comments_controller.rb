class CommentsController < ApplicationController
	before_action :logged_in_user, only: [  :edit , :update, :destroy]
	before_action :correct_user, only: [ :edit, :update, :destroy]

	def create
		@post = Post.find(comment_params[:post_id])
		@comment = current_user.comments.build(comment_params)
		@comments = [@comment]
		if @comment.save

			respond_to do |format|
				format.html {redirect_to request.referrer || root_url}
				format.js
			end
		else
			flash.now[:danger] = "error comment couldn't be created"
			respond_to do |format|
				format.html {redirect_to request.referrer || root_url}
				format.js
			end
		end

	end

	def edit
		@post = Post.find(params[:post])
		@comment = Comment.find(params[:id])
		@comments = [@comment]
		respond_to do |format|
			format.html 
			format.js
		end
	end

	def update
		@comment_new = current_user.comments.build
		@comment = Comment.find(params[:id])
		@post = Post.find(@comment.post_id)
		if @comment.update_attributes(comment_params)
			respond_to do |format|
				format.html { redirect_to  root_url}
				format.js
			end
		else 
			flash[:danger] = "error in comment edition"
			respond_to do |format|
				format.html { redirect_to request.referrer || root_url }
				format.js
			end
		end
	end

	def destroy 
		@comment.destroy
		flash[:success] = "Comment deleted"
		redirect_to request.referrer || root_url			
	end

	def load_more_comments
		@post = Post.find(comment_params[:post_id])
		@pagy_comment, @comments = pagy(@post.comments, page: comment_params[:page_number] ,items: 4, link_extra: 'data-remote="true"')
		if @pagy_comment.last == comment_params[:page_number].to_i
			@last = true
		else
			@last = false
		end
		@next_page = comment_params[:page_number].to_i + 1
	end

	private  

	 def comment_params
	 	params.require(:comment).permit(:content, :user_id, :post_id, :page_number)
	 end

	 def correct_user
	 	@comment = current_user.comments.find(params[:id])
	 	unless @comment
	 	 	redirect_to root_url
	 	end 
	 end
end

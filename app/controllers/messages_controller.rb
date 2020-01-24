class MessagesController < ApplicationController

	def create
		@message = current_user.sended_messages.build(message_params)
		@relationship = Relationship.friendship(current_user.id, @message.receiver_id)
		if @message.save
			ActionCable.server.broadcast "chat_#{@relationship.id}_channel", 
			content: @message.content,
			sender_avatar_link: url_for(current_user.avatar),
			sender_name: current_user.user_name,
			relationship_id: @relationship.id
		end
	end

	def mini_chat
		if params[:page] != nil
			@load_messages = true
		else 
			@load_messages = false
		end
		@friend = User.find(message_params[:friend_id])
		@message = current_user.sended_messages.build
		@relationship = Relationship.friendship(current_user.id, @friend.id)
		@pagy, @messages = pagy(Message.messages_between_users(current_user,@friend ),   page: params[:page] ,  items: 8, link_extra: 'data-remote="true"')
		respond_to do |format|
			format.html {redirect_to gamechat_url}
			format.js
		end
	end

	private

	def message_params
		params.require(:message).permit(:content, :sender_id ,:receiver_id, :friend_id)
	end
end

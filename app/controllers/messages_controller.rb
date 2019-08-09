class MessagesController < ApplicationController

	def create
		@message = current_user.sended_messages.build(message_params)
		if @message.save

			ActionCable.server.broadcast 'chat_channel', 
			content: @message.content,
			sender_name: @message.sender.user_name,
			sender_id: @message.sender_id
		
		end
	end

	private

	def message_params
		params.require(:message).permit(:content, :sender_id ,:receiver_id)
	end
end

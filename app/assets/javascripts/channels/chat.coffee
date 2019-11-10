document.addEventListener("turbolinks:load", ->(
	  gamechat = document.querySelector("#game_chat");
	  if gamechat != null 
	  	App.chat = App.cable.subscriptions.create {channel: "ChatChannel", 
	  	chat_room_id: JSON.parse(gamechat.getAttribute('data-chat-room-id'))}, 
			
			  {connected: ->
			    # Called when the subscription is ready for use on the server,

			  disconnected: ->
			    # Called when the subscription has been terminated by the server,

			  received: (message) ->
			    # Called when there's incoming data on the websocket for this channel'
			    if document.querySelector("#game_chat") != null 
				    messages = document.querySelector("#message_list");			    
				   	messages.insertAdjacentHTML("beforeend", "<li class=user"+message.sender_id+">"+message.sender_name+": "+ message.content+"</li>");
				   	if messages.scrolltop != 0
				   		messages.scrollTop = messages.scrollHeight - messages.clientHeight;
			    }

			
	
  )
)

    
	




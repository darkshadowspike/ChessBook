connect_chat_channel= ()-> (

	  connect = (message) ->(

	  	if !App["Chat_#{message.getAttribute('data-relationship-id')}"]
		  	
		  	App["Chat_#{message.getAttribute('data-relationship-id')}"] = App.cable.subscriptions.create {channel: "ChatChannel", 
		  	chat_room_id: JSON.parse(message.getAttribute('data-relationship-id'))}, 			
				  {connected: (message) ->
				    # Called when the subscription is ready for use on the server,

				  disconnected: ->
				    # Called when the subscription has been terminated by the server,

				  received: (message) ->
				    # Called when there's incoming data on the websocket for this channel'
				    messages = document.querySelector("#message_list_#{message.relationship_id}");
				    if messages != null
				    	if  message.sender_name == chat_data.user_name    
					   		messages.insertAdjacentHTML("beforeend", "<li class='current_user_message'><p>#{message.content}</p></li>");
					   	else
					   		messages.insertAdjacentHTML("beforeend", "<li class='friend_message'><img src=#{message.sender_avatar_link}><p>#{message.content}</p></li>");					   		

					   	if messages.scrolltop != 0
					   		messages.scrollTop = messages.scrollHeight - messages.clientHeight;
				    }	

	  )

	  messages_lists = document.querySelectorAll(".message_list");
	  if messages_lists 
	  	connect message for message in messages_lists 


	  connect_chat_action_cable_button = document.querySelector("#connect_chat_action_cable");
	  if connect_chat_action_cable_button != null
    	connect_chat_action_cable_button.addEventListener("click", connect_chat_channel);
)
			
document.addEventListener("turbolinks:load", connect_chat_channel);





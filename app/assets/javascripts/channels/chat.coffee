App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (message) ->
    # Called when there's incoming data on the websocket for this channel'

    messages = document.querySelector("#message_list");

   	messages.insertAdjacentHTML("beforeend", "<li class=user"+message.sender_id+">"+message.sender_name+": "+ message.content+"</li>");
    
	




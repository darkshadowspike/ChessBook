document.addEventListener("turbolinks:load", ->(
	user_id_input = document.querySelector("#user_id");
	if user_id_input != null 
		App.status = App.cable.subscriptions.create {channel: "StatusChannel",
		user_id: JSON.parse(user_id_input.value)},
		  {connected: ->
		    # Called when the subscription is ready for use on the server

		  disconnected: ->
		    # Called when the subscription has been terminated by the server

		  received: (data) ->
		    # Called when there's incoming data on the websocket for this channel
		  }
	)
)
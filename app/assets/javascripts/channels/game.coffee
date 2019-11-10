document.addEventListener("turbolinks:load", ->(
	  gamechat = document.querySelector("#game_chat");
	  if gamechat != null 
	  	App.game = App.cable.subscriptions.create {channel: "GameChannel", 
	  	chat_room_id: JSON.parse(gamechat.getAttribute('data-chat-room-id'))}, 
		
			  {connected: ->
			    # Called when the subscription is ready for use on the server,

			  disconnected: ->
			    # Called when the subscription has been terminated by the server,

			  received: (gamedata) ->
			    # Called when there's incoming data on the websocket for this channel'
			    if gamedata.new_game == true
			    	document.location.reload(true);
			    else
			    	if gamedata.move_info[2]
			    		document.location.reload(true);
			    	else
				    	if player_data.your_turn
				    		end_turn(gamedata.player_data, gamedata.move_info );
				    	else
				    		begin_turn(gamedata.player_data, gamedata.move_info );

			    }

  )
)

    
	
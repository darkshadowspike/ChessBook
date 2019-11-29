

window.onload = function(){
	
	if (document.readyState === "complete" ){
		if (document.querySelector("#game_chat") != null){
					playable_pieces();
					add_message_autoload();
		}
	}	
};




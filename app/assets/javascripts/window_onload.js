

window.onload = function(){

	
	
	if (document.readyState === "complete" ){
		if (document.querySelector("#game_chat") != null){
					playable_pieces();
					add_message_autoload();
		}
		window.addEventListener('resize', loadNextPage);
		window.addEventListener('scroll', loadNextPage);
		window.addEventListener('load',   loadNextPage);
		document.querySelector("#friendship_request_notification").addEventListener('click',press_navbar_button);
		document.querySelector("#general_notification").addEventListener('click',press_navbar_button);
		document.querySelector("#new_message_notification").addEventListener('click',press_navbar_button);
		document.addEventListener("click", press_outside_navbar_display);
	}	
};




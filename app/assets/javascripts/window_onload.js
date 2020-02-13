

window.onload = function(){

	
	
	if (document.readyState === "complete" ){
		if (document.querySelector("#game_chat") != null){
					playable_pieces();
					add_message_autoload();
		}
		window.addEventListener('resize', loadNextPage);
		window.addEventListener('scroll', loadNextPage);
		window.addEventListener('load',   loadNextPage);
		buttons_assign();
		document.addEventListener("click", press_outside_navbar_display);
		document.addEventListener("click", press_outside_overlay);

	}	
};




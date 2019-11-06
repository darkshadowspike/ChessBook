
function add_message_autoload (){
		let messages = document.querySelector("#message_list")

		if (messages){
			messages.scrollTop = messages.scrollHeight - messages.clientHeight;

			let loadNextPageMessages = function(){
				if(document.querySelector("#next_link") == null){
					messages.removeEventListener('resize', loadNextPageMessages);
					messages.removeEventListener('scroll', loadNextPageMessages);
					messages.removeEventListener('load',   loadNextPageMessages);
					document.querySelector(".page.next.disabled").setAttribute("style", "display:none;");
					return;
				}

				if(document.querySelector("#next_link").hasAttribute("loading")){ return } //checks for the loading attribute to stop if loading
						
				if ( messages.scrollTop < Math.round((messages.scrollHeight ) * 13 /100)){
					document.querySelector("#next_link").click();
					document.querySelector("#next_link").setAttribute("loading", true)
				}
			}

			messages.addEventListener('resize', loadNextPageMessages);
			messages.addEventListener('scroll', loadNextPageMessages);
			messages.addEventListener('load',   loadNextPageMessages);
		}
}


window.onload = function(){
	
	if (document.readyState === "complete" ){
		playable_pieces();
		add_message_autoload();
	}	
};




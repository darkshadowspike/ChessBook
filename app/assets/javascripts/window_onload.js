function put_chessboard (){

	for ( y = 1; y<= 8; y++ ){
			for (  x = 8; x >= 1 ; x--){
				switch(x){
					case 1:
				        xs="A";
				        break;
				    case 2:
				        xs="B";
				        break;
				    case 3:
				        xs="C";
				        break;
				    case 4:
				        xs="D";
				        break;
				    case 5:
				        xs="E";
				        break;
				    case 6:
				        xs="F";
				        break;
				    case 7:
				        xs="G";
				        break;
				    case 8:
				        xs="H";
				        break;
				}

				chessboard.insertAdjacentHTML("afterbegin", `
					<li> 
						<form action="/gamechat" accept-charset="UTF-8" method="get" data-remote="true"><input name="utf8" type="hidden" value="✓">	
							<input type="hidden" name="board_id" id="board_id" value="${xs + y}">	
							<input id= ${xs + y} type="submit" value="${xs + y}" >
						</form>				
							
					</li>
				`);
			}
	}
}

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
		put_chessboard();
		add_message_autoload();
	}	
};




let loadNextPageMessages = function(e){
	next_link_button = document.querySelector(`#next_link_${e.target.getAttribute('data-relationship-id')}`) ;
	if(next_link_button == null){
		e.target.removeEventListener('resize', loadNextPageMessages);
		e.target.removeEventListener('scroll', loadNextPageMessages);
		e.target.removeEventListener('load',   loadNextPageMessages);
		document.querySelector(".page.next.disabled").setAttribute("style", "display:none;");
		return;
	}

	if(next_link_button.hasAttribute("loading")){ return } //checks for the loading attribute to stop if loading
						
	if ( e.target.scrollTop < Math.round((e.target.scrollHeight ) * 3 /100)){
		e.target.scrollTop = Math.round((e.target.scrollHeight ) * 10 /100)
		next_link_button.click();
		next_link_button.setAttribute("loading", true)
	}
}



function add_message_autoload (){
		let messages = document.querySelectorAll(".message_list");
			
		if (messages){
				messages.forEach(message_list => {
					message_list.scrollTop = message_list.scrollHeight - message_list.clientHeight;
					message_list.addEventListener('resize', loadNextPageMessages);
					message_list.addEventListener('scroll', loadNextPageMessages);
					message_list.addEventListener('load',   loadNextPageMessages);
				})

		}
}

function close_mini_box(e){
	chat_box = document.querySelector(`#chat_box_${e.target.getAttribute('value')}`);
	if(chat_box != null){
		chat_space.removeChild(chat_box);
	}
}


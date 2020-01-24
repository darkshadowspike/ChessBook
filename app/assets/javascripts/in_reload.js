window.onbeforeunload = function () {

  window.scrollTo(0, 0);
   if (document.readyState === "complete" && document.querySelector("#game_chat") != null ){
	messages = document.querySelectorAll(".message_list");
	messages.forEach(message_list => {
		message_list.scrollTop = message_list.scrollHeight - message_list.clientHeight;
	})
	window.addEventListener('resize', loadNextPage);
	window.addEventListener('scroll', loadNextPage);
	window.addEventListener('load',   loadNextPage);
	
  }
}
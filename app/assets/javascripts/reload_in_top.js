window.onbeforeunload = function () {
  window.scrollTo(0, 0);
  if (document.readyState === "complete" ){
	messages = document.querySelector("#message_list");
	messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
}
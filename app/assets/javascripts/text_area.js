function pressEnterComment(e){
	var keycode = e.keyCode;
	if(keycode == 13){
		parent = e.target.parentNode;
		parent.children[1].click();
	}
}
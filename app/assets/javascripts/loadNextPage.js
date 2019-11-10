

let loadNextPage = function(){

	if(document.querySelector("#next_link") == null || document.querySelector("#game_chat") != null){
		window.removeEventListener('resize', loadNextPage);
		window.removeEventListener('scroll', loadNextPage);
		window.removeEventListener('load',   loadNextPage);
		if (document.querySelector("#game_chat") == null){
			document.querySelector(".page.next.disabled").setAttribute("style", "display:none;");
		}
		return;
	}
	if(document.querySelector("#next_link").hasAttribute("loading")){ return } //checks for the loading attribute to stop if loading
	// sets window bottom variable using the scrolltop from the window (the amount of pixel that at element has scrolled down) and the windows height
	let wBottom = document.documentElement.scrollTop + window.innerHeight;
	// sets element bottom variable using the BoundingClientRect method to get its bottom in relation with the viewport plus the height of the element
	let elBottom =document.querySelector("#posts").getBoundingClientRect().bottom + document.querySelector("#posts").offsetHeight -500;
	
	//when ammount of page scrolled + height of the windows becomes higher than the element and the distance with its bottom plus 500px it clicks on the
	//link and puts the attribute loading until the link is replaced
	if(wBottom > elBottom){
		document.querySelector("#next_link").click();
		document.querySelector("#next_link").setAttribute("loading", true)
	}

};

window.addEventListener('resize', loadNextPage);
window.addEventListener('scroll', loadNextPage);
window.addEventListener('load',   loadNextPage);


let loadNextPage = function(){
	next_link = document.querySelector("#next_link");
	
	if(next_link == null ){
		window.removeEventListener('resize', loadNextPage);
		window.removeEventListener('scroll', loadNextPage);
		window.removeEventListener('load',   loadNextPage);
		if (document.querySelector("#game_chat") != null){
			document.querySelector(".page.next.disabled").setAttribute("style", "display:none;");
		}
		
		return;
	}

	if(next_link.hasAttribute("loading")){ return } //checks for the loading attribute to stop if loading
	// sets window bottom variable using the scrolltop from the window (the amount of pixel that at element has scrolled down) and the windows height
	let wBottom = document.documentElement.scrollTop + window.innerHeight;
	// sets element bottom variable using the BoundingClientRect method to get its bottom in relation with the viewport plus the height of the element
	let elBottom =document.querySelector("#posts").getBoundingClientRect().bottom + document.querySelector("#posts").offsetHeight -500;
	
	//when ammount of page scrolled + height of the windows becomes higher than the element and the distance with its bottom plus 500px it clicks on the
	//link and puts the attribute loading until the link is replaced
	if(wBottom > elBottom){
		next_link.click();
		next_link.setAttribute("loading", true)
	}

};

window.addEventListener('resize', loadNextPage);
window.addEventListener('scroll', loadNextPage);
window.addEventListener('load',   loadNextPage);

let remove_delete_button = function (){
	let parent = this.parentNode;
	document.querySelector("#posts").removeChild(parent);
	
};

let  assign_delete_buttons= function(){
	let delete_buttons = document.querySelectorAll("a[data-method=delete]");
	delete_buttons.forEach( button => {		
		button.addEventListener("click", remove_delete_button);
	});
};

if (document.readyState === "complete" ){
	assign_delete_buttons();
}
else{
	document.addEventListener("DOMContentLoaded", assign_delete_buttons);
}


let loadNextPage = function(){
	next_link = document.querySelector("#next_link");
	
	if(next_link != null ){

		if (document.querySelector("#game_chat") != null ){
			document.querySelector(".page.next.disabled").setAttribute("style", "display:none;");
		}

		if(next_link.hasAttribute("loading")){ return } //checks for the loading attribute to stop if loading
		// sets window bottom variable using the scrolltop from the window (the amount of pixel that at element has scrolled down) and the windows height
		let wBottom = document.documentElement.scrollTop + window.innerHeight;

		content = document.querySelector("#posts");
		if(content == null){
			content = document.querySelector("#show_users")
		}
		// sets element bottom variable using the BoundingClientRect method to get its bottom in relation with the viewport plus the height of the element
		
		let elBottom =content.getBoundingClientRect().bottom + content.offsetHeight -500;
		
		//when ammount of page scrolled + height of the windows becomes higher than the element and the distance with its bottom plus 500px it clicks on the
		//link and puts the attribute loading until the link is replaced
		if(wBottom > elBottom){
			next_link.click();
			next_link.setAttribute("loading", true)
		}

	}

};


	

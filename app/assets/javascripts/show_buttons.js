function press_avatar_button(){
	document.querySelector("#overlay").classList.remove("hidden");
	document.querySelector("#avatar_form").classList.remove("hidden");    
}

function press_wall_button(){
	document.querySelector("#overlay").classList.remove("hidden");
	document.querySelector("#mural_form").classList.remove("hidden");   

}

function press_outside_overlay(e){
	overlay = document.querySelector("#overlay");
	overlay_inner = document.querySelector("#overlay-inner");
	if(!overlay.classList.contains("hidden")){
		is_click_inside = overlay_inner.contains(e.target);
	}

	if (typeof is_click_inside != "undefined" && is_click_inside !== null && !is_click_inside){

		if(!overlay.classList.contains("pressed")){
			overlay.classList.add("pressed");
		}else{
			overlay.classList.remove("pressed");
			overlay.classList.add("hidden");
			overlay_inner.childNodes.forEach(child =>{
				if(typeof child.classList != "undefined"){
					child.classList.add("hidden");
				}

			})
		}
	}
};

function overlay_media(){
	console.log("papaya");
}
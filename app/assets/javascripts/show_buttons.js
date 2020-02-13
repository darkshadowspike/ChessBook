function press_avatar_button(){
	document.querySelector("#overlay").classList.remove("hidden");
	document.querySelector("#avatar_form").classList.remove("hidden");    
	overlay_inner = document.querySelector("#overlay-inner");
	overlay_inner.classList.add("upload_image");
	overlay_inner.classList.remove("hidden");
}

function press_wall_button(){
	document.querySelector("#overlay").classList.remove("hidden");
	document.querySelector("#mural_form").classList.remove("hidden"); 
	overlay_inner = document.querySelector("#overlay-inner");  
	overlay_inner.classList.add("upload_image");
	overlay_inner.classList.remove("hidden");
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
			if (overlay_inner.classList.contains("upload_image")){
				overlay_inner.classList.remove("upload_image");
			} else if (overlay_inner.classList.contains("image_video_display")){
				overlay_inner.classList.remove("image_video_display");
				container = document.querySelector("#overlay_inner_media_display");
				container.classList.add("hidden");
				container.children[0].innerHTML = ""
				container.children[1].innerHTML = ""
			} else if (overlay_inner.classList.contains("image_user_display")){
				container = document.querySelector("#overlay_inner_user_media_display");
				container.classList.add("hidden"); 
				container.innerHTML = ""
			}
			overlay_inner.classList.add("hidden'");
			overlay_inner.childNodes.forEach(child =>{
				if(typeof child.classList != "undefined"){
					child.classList.add("hidden");
				}

			})
		}
	}
};

function overlay_media(e){
	document.querySelector("#overlay").classList.remove("hidden");
	overlay_inner = document.querySelector("#overlay-inner");
	overlay_inner.classList.add("image_video_display");
	overlay_inner.classList.remove("hidden");
	container = document.querySelector("#overlay_inner_media_display");
	container.classList.remove("hidden");
	post = e.target.parentNode.parentNode.parentNode;
	container.children[0].innerHTML = post.children[1].children[2].innerHTML 
	container.children[1].innerHTML = post.innerHTML 
	container.children[1].children[1].children[2].classList.add("hidden");

	post_comments = container.children[1].children[1].children[3];
	post_comments.children[(post_comments.children.length - 1)].children[4].addEventListener("keydown",pressEnterComment);

}

function overlay_user_img(e){
	document.querySelector("#overlay").classList.remove("hidden");
	overlay_inner = document.querySelector("#overlay-inner");
	overlay_inner.classList.add("image_user_display");
	overlay_inner.classList.remove("hidden");
	container = document.querySelector("#overlay_inner_user_media_display");
	container.classList.remove("hidden"); 
	container.innerHTML = e.target.outerHTML
}

function add_event_new_media(){
        media_clickable = document.querySelectorAll(".media_new")	

        if(media_clickable.length >0){
            media_clickable.forEach(media =>{
            	media.classList.remove("media_new")
                media.addEventListener('click', overlay_media); 
            }) 
        }
}

function add_event_user_media(){
	user_imgs = document.querySelectorAll(".user_img")
	if(user_imgs.length > 0){
		    user_imgs.forEach(media =>{
                media.addEventListener('click',  overlay_user_img); 
            }) 
	}
}

function  add_event_new_comment_text_area(){
	    new_posts_text_area = document.querySelectorAll(".new_post_comment_text_area")	

        if(new_posts_text_area.length >0){
            new_posts_text_area.forEach(element =>{
            	element.classList.remove("new_post_comment_text_area");
                element.addEventListener("keydown",pressEnterComment);
            }) 
        }
}


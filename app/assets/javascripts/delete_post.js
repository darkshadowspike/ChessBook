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



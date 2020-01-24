function checkup(){
	button = document.querySelector("#checkup_button");
	button.click();
}

checkup_interval = setInterval(checkup, 50000)
function buttons_assign(){
                request_button = document.querySelector("#friendship_request_notification");
                if(request_button != null){
                  request_button.addEventListener('click',press_navbar_button);
                }

                posts_button = document.querySelector("#general_notification")
                if(posts_button != null){
                    posts_button.addEventListener('click',press_navbar_button);
                }

                messages_display_button = document.querySelector("#new_message_notification")
                if(messages_display_button != null){
                  messages_display_button.addEventListener('click',press_navbar_button); 
                }

                edit_wall_button = document.querySelector("#edit_wall_button");

                if(edit_wall_button != null){
                  edit_wall_button.childNodes[1].addEventListener('click',press_wall_button); 
                }

                edit_avatar_button = document.querySelector("#edit_avatar_button");

                if(edit_avatar_button != null){
                  edit_avatar_button.childNodes[1].addEventListener('click',press_avatar_button); 
                }	

                form_media_button = document.querySelector("#form_media_button");

                if(form_media_button!= null){
                  form_media_button.addEventListener('click',(e)=>{document.querySelector("#form_media_field").click() }); 
                }

                media_clickable = document.querySelectorAll(".clickable_media")	

                if(media_clickable.length >0){
                	media_clickable.forEach(media =>{
                		media.addEventListener('click', overlay_media); 
                	}) 
                }
}
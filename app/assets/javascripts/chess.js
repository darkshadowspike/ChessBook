function submit_move(e){
    form  = document.querySelector("#chess_form")
    form.insertAdjacentHTML("afterbegin", `<input type="hidden" id="chessgame_start_pos" name="chessgame[start_pos]" value=${button_id}>`);
    form.insertAdjacentHTML("afterbegin", `<input type="hidden" id="chessgame_new_pos" name="chessgame[new_pos]" value=${e.target.id}>`);
    e.target.type = 'submit'
}

function submit_move_with_promotion(e){
    form  = document.querySelector("#chess_form")
    form.insertAdjacentHTML("afterbegin", `<input type="hidden" id="chessgame_start_pos" name="chessgame[start_pos]" value=${button_id}>`);
    form.insertAdjacentHTML("afterbegin", `<input type="hidden" id="chessgame_new_pos" name="chessgame[new_pos]" value=${e.target.id}>`);
    form.insertAdjacentHTML("afterbegin", `
        <div id="promotion">
            <h4>Choose a piece for the promotion</h4>
            <ul id="promotion_buttons">
                <li><button type="submit" name="chessgame[promotion]" value="Queen">Queen</button></li>
                <li><button type="submit" name="chessgame[promotion]" value="Knight">Knight</button></li>
                <li><button type="submit" name="chessgame[promotion]" value="Rook">Rook</button></li>
                <li><button type="submit" name="chessgame[promotion]" value="Bishop">Bishop</button></li>
            </ul>
        </div>
    `);
}

function select_move(e){
    clean_board(true)
    e.target.classList.add('selected');
    let pawn =  e.target.classList.contains('Pawn');
    if(pawn){ console.log(pawn)};
    button_id = e.target.id;
    posible_moves = moves_for_piece.call(player_data,`${button_id}`);
    squares = document.querySelectorAll(".board_box");
    squares.forEach(
        square => {
            if( square.id != button_id){ 
                s_id = square.id 
                if(posible_moves.includes(s_id) ) {
                    square.classList.add('selectable_for_move');
                    if(pawn && (parseInt(s_id[1]) == 1 ||parseInt(s_id[1]) == 8 ) ){
                        square.classList.add('selectable_for_move2');
                        square.addEventListener('click', submit_move_with_promotion)
                    }else{
                        square.addEventListener('click', submit_move)
                    }                    
                }
            }
        }
    )
}

function playable_pieces(){
    check  = document.querySelector("#checkstate");
    if (player_data.your_turn){
        if (!player_data.checkmate){
            player_data.pieces.forEach(
                piece =>{
                    let button = document.querySelector(`#${piece.pos}`)
                    button.classList.add("movable");
                    button.addEventListener('click', select_move);
                }
            )
            if (player_data.check){
                check.innerText = "You are in Check!"
            }
        } else {
            check.innerText = "Checkmate! You lose!"
        }
    } else {
        check_victory()
    }
}

function moves_for_piece (pos){
		posible_moves = []
        this.pieces.forEach(piece=>{
        	if(piece.pos == pos){
        		
        		 posible_moves  = piece.posible_moves
        	}
        })

        return posible_moves
}

function clean_board(for_playable_piece = false){
   let form  = document.querySelector("#chess_form");
   let squares = document.querySelectorAll(".board_box");
   let check  = document.querySelector("#checkstate");
   check.innerText = "";
   squares.forEach(
        square => {

                if(square.classList.contains('movable') ){
                    square.classList.remove('selected');
                    if (!for_playable_piece){
                        square.classList.remove('movable');
                        square.removeEventListener('click', select_move);
                    }

                }
                if(square.classList.contains('selectable_for_move') ){
                    square.type = 'button';
                    square.classList.remove('selectable_for_move');
                    square.removeEventListener('click', submit_move);
                }    
        }
    )
    if (input1 = document.querySelector("#chessgame_start_pos") ){
        form.removeChild(input1);
    }

    if (input2 = document.querySelector("#chessgame_new_pos") ){
      form.removeChild(input2);  
    }
                

}

function update_board(start_pos, new_pos){
       start_square = document.querySelector(`#${start_pos}`);
       new_square = document.querySelector(`#${new_pos}`);
       player_turn = document.querySelector("#players_turn");
       new_square.innerHTML = " ";
       new_square.appendChild(start_square.children[0]);  
       delete_piece_class(new_square);
       add_piece_class(start_square , new_square) ; 
       start_square.innerHTML = " ";
       delete_piece_class(start_square);
       if (player_data.your_turn){
        player_turn.innerHTML = "Your turn"
       } else {
        player_turn.innerHTML = "Enemy's turn"
       };
}

function check_victory(){
        if(player_data.enemy_checkmate){
            check  = document.querySelector("#checkstate");
            check.innerText = "Checkmate! You won!"
        }
}

function end_turn(new_data, move_info){
        new_data.check ? enemy_check = true : enemy_check = false
        new_data.checkmate ? enemy_checkmate = true : enemy_checkmate = false
        player_data = {enemy_check: enemy_check, enemy_checkmate: enemy_checkmate, your_turn: false}
        Object.freeze(player_data)
        clean_board()
        update_board(move_info[0], move_info[1])
        check_victory()
}

function begin_turn(new_data, move_info){
        new_data.your_turn = true
        player_data = new_data
        Object.freeze(player_data)
        clean_board()
        update_board(move_info[0], move_info[1])
        playable_pieces()
}

 function delete_piece_class(square_element){
    if(square_element.classList.contains("Pawn")){
        square_element.classList.remove("Pawn")
    }
    if(square_element.classList.contains("Queen")){
        square_element.classList.remove("Queen")
    }
    if(square_element.classList.contains("King")){
        square_element.classList.remove("King")
    }
    if(square_element.classList.contains("Rook")){
        square_element.classList.remove("Rook")
    }
    if(square_element.classList.contains("Knight")){
        square_element.classList.remove("Knight")
    }
    if(square_element.classList.contains("Bishop")){
        square_element.classList.remove("Bishop")
    }
    if(!square_element.classList.contains("Node")){
        square_element.classList.add("Node")
    }
 }

  function add_piece_class(start_square_element , new_square_element){

    if(new_square_element.classList.contains("Node")){
        new_square_element.classList.remove("Node")
    }
    if(start_square_element.classList.contains("Pawn")){
        new_square_element.classList.add("Pawn")
    }
    if(start_square_element.classList.contains("Queen")){
        new_square_element.classList.add("Queen")
    }
    if(start_square_element.classList.contains("King")){
        new_square_element.classList.add("King")
    }
    if(start_square_element.classList.contains("Rook")){
        new_square_element.classList.add("Rook")
    }
    if(start_square_element.classList.contains("Knight")){
        new_square_element.classList.add("Knight")
    }
    if(start_square_element.classList.contains("Bishop")){
        new_square_element.classList.add("Bishop")
    }

 }
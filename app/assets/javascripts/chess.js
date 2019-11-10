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
        <ul id="promotion_buttons">
            <div>Choose a piece for the promotion</div>
            <li><button type="submit" name="chessgame[promotion]" value="Queen">Queen</button></li>
            <li><button type="submit" name="chessgame[promotion]" value="Knight">Knight</button></li>
            <li><button type="submit" name="chessgame[promotion]" value="Rook">Rook</button></li>
            <li><button type="submit" name="chessgame[promotion]" value="Bishop">Bishop</button></li>
        </ul>
    `);
}

function select_move(e){
    clean_board(true)
    e.target.classList.add('selected');
    let pawn =  e.target.classList.contains('Pawn');
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
                check.innerText = "Check"
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
       new_square.innerText= start_square.innerHTML;
       start_square.innerHTML = " ";
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
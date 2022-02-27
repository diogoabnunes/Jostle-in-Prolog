:- [display].
:- [jostle].
:- [input].

/*
* init_board(Board)
* Configuração do tabuleiro inicial.
*/
init_board([
    [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ','V','A','V','A','V','A',' ',' '],
    [' ',' ','A','V','A','V','A','V',' ',' '],
    [' ',' ','V','A',' ',' ','V','A',' ',' '],
    [' ',' ','A','V',' ',' ','A','V',' ',' '],
    [' ',' ','V','A','V','A','V','A',' ',' '],
    [' ',' ','A','V','A','V','A','V',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']
]).

/*
* init_player(Player)
* O jogador V é sempre o primeiro a jogar.
*/
init_player('V').

/*
* initial_state(-Board, -Player)
* Configuração do estado do jogo inicial.
*/
initial_state(Board,Player):-
    init_board(Board),
	init_player(Player).

/*
* move(+GameState, +Move, -NewGameState)
* Predicado de movimento de uma peça.
*/
move(Board-Player, Col-Row-MoveDirection, NewBoard-Next) :-
    get_pos_after_move(Col, Row, MoveDirection, Mcol, Mrow),
    verify_available(Board, Mcol, Mrow),
    get_newBoard(Board, Player, Col, Row, Mcol, Mrow, NewBoard),
    get_checker_points(Board, Col, Row, Points),
    get_checker_points(NewBoard, Mcol, Mrow, NewPoints),
    verify_points(Points, NewPoints), 
    change_player(Player, Next).

move(_, _, _) :-
    !,
    not_valid, nl,nl,
    fail.

/*
* game_pvp(+Board, +Player)
* Modo de jogo 1: Player 1 vs. Player 2.
*/
game_pvp(Board, Player):-
    value(Board-Player, 'V', ValueV),
    value(Board-Player, 'A', ValueA),
    display_game(Board-Player-ValueV-ValueA),
    get_new_play_cell(Col, Row),
    verify_owner(Board, Col, Row, Player),
    get_new_play_move(MoveDirection, Board, Player),
    move(Board-Player, Col-Row-MoveDirection, NewBoard-Next),
    game_over(NewBoard, Next),
    game_pvp(NewBoard, Next).

game_pvp(Board, Player):-
    not_valid, nl,nl,
    game_pvp(Board, Player).

/*
* game_pvc(+Board, +Player)
* Modo de jogo 2: Player vs. Computer.
*/
game_pvc(Board, Player):-
    Player == 'V',
    value(Board-Player, 'V', ValueV),
    value(Board-Player, 'A', ValueA),
    display_game(Board-Player-ValueV-ValueA),
    get_new_play_cell(Col, Row),
    verify_owner(Board, Col, Row, Player),
    get_new_play_move(MoveDirection, Board, Player),
    move(Board-Player, Col-Row-MoveDirection, NewBoard-Next),
    game_over(NewBoard, Next),
    game_pvc(NewBoard, Next).

game_pvc(Board, Player):-
    Player == 'A',
    value(Board-Player, 'V', ValueV),
    value(Board-Player, 'A', ValueA),
    display_game(Board-Player-ValueV-ValueA),
    choose_move(Board-Player, 1, [Col, Row, Move]),
    display_computer_play([Col, Row, Move]),
    get_pos_after_move(Col, Row, Move, Mcol, Mrow),
    get_newBoard(Board, Player, Col, Row, Mcol, Mrow, NewBoard),
    change_player(Player, Next),
    game_over(NewBoard, Next),
    game_pvc(NewBoard, Next).

game_pvc(Board, Player):-
    not_valid, nl,nl,
    game_pvc(Board, Player).

/*
* game_cvp(+Board, +Player)
* Modo de jogo 3: Computer vs. Player.
*/
game_cvp(Board, Player):-
    Player == 'A',
    value(Board-Player, 'V', ValueV),
    value(Board-Player, 'A', ValueA),
    display_game(Board-Player-ValueV-ValueA),
    get_new_play_cell(Col, Row),
    verify_owner(Board, Col, Row, Player),
    get_new_play_move(MoveDirection, Board, Player),
    move(Board-Player, Col-Row-MoveDirection, NewBoard-Next),
    game_over(NewBoard, Next),
    game_cvp(NewBoard, Next).

game_cvp(Board, Player):-
    Player == 'V',
    value(Board-Player, 'V', ValueV),
    value(Board-Player, 'A', ValueA),
    display_game(Board-Player-ValueV-ValueA),
    choose_move(Board-Player, 1, [Col, Row, Move]),
    display_computer_play([Col, Row, Move]),
    get_pos_after_move(Col, Row, Move, Mcol, Mrow),
    get_newBoard(Board, Player, Col, Row, Mcol, Mrow, NewBoard),
    change_player(Player, Next),
    game_over(NewBoard, Next),
    game_cvp(NewBoard, Next).

game_cvp(Board, Player):-
    not_valid, nl,nl,
    game_pvc(Board, Player).

/*
* game_cvc(+Board, +Player)
* Modo de jogo 4: Computer 1 vs. Computer 2.
*/
game_cvc(Board, Player):-
    value(Board-Player, 'V', ValueV),
    value(Board-Player, 'A', ValueA),
    display_game(Board-Player-ValueV-ValueA),
    choose_move(Board-Player, 1, [Col, Row, Move]),
    display_computer_play([Col, Row, Move]),
    get_pos_after_move(Col, Row, Move, Mcol, Mrow),
    get_newBoard(Board, Player, Col, Row, Mcol, Mrow, NewBoard),
    change_player(Player, Next),
    game_over(NewBoard, Next),
    game_cvc(NewBoard, Next).

game_cvc(Board, Player):-
    not_valid, nl,nl,
    game_cvc(Board, Player).

/*
* game_over(+Board, +Player)
* Verificação de fim do jogo.
*/
game_over(Board, Player):-
    valid_moves(Board-Player, Plays), 
    game_over(Board, Player, Plays).

/*
* game_over(+Board, +Player, +Plays)
* Se a lista de jogadas válidas Plays for vazia, o jogo termina, caso contrário prossegue o ciclo de jogo.
*/
game_over(Board, Player, []):-
    nl,
    display_board(Board),
    display_game_name,
    display_game_over,
    change_player(Player, Winner),
    display_winner(Winner),
    abort.
game_over(_, _, _).
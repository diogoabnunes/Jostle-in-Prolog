
/*
* menu_game_mode
* Imprime as opções de modo de jogo
*/
menu_game_mode :-
	nl,write('Choose the game mode: '),nl,nl,
	write('1. Player 1 vs. Player 2'),nl,
	write('2. Player vs. Computer'),nl,
	write('3. Computer vs. Player'),nl,
	write('4. Computer 1 vs. Computer 2'),nl,
	write('0. Quit').

/*
* menu_play_moves
* Imprime as opções de movimento da peça
*/
menu_play_moves :-
	nl,write('Choose the next move: '),nl,
	write('1. Right'),nl,
	write('2. Left'),nl,
	write('3. Up'),nl,
	write('4. Down'),nl,
	write('0. Give Up').

/*
* get_new_play_cell(-IntCol, -IntRow)
* Pede que o utilizador escolha uma coluna e uma linha de uma peça.
*/
get_new_play_cell(IntCol, IntRow):-
    write('Column (a-j): '), nl,
    read(Col),
    verify_col_choice(Col),
    code(Col, IntCol),
    write('Row (1-10): '), nl,
    read(Row),
    verify_row_choice(Row),
    IntRow is Row - 1.

/*
* get_new_play_move(-Move, +Board, +Player)
* Pede que o utilizador escolha uma direção para o movimento da peça e faz a verificação do input.
*/
get_new_play_move(Move, Board, Player):-
    menu_play_moves,nl,
    read(Move),
    verify_move_choice(Move, Board, Player).

/*
* verify_col_choice(+Cell):-
* Verifica que a coluna escolhida está entre 'a' e 'j'.
*/
verify_col_choice(Col):-
   (Col == 'a'; 
    Col == 'b'; 
    Col == 'c'; 
    Col == 'd'; 
    Col == 'e'; 
    Col == 'f'; 
    Col == 'g'; 
    Col == 'h'; 
    Col == 'i';
    Col == 'j') .

/*
* verify_row_choice(+Row)
* Verifica que a linha escolhida está entre 1 e 10.
*/
verify_row_choice(Row):-
   (Row == 1; 
    Row == 2; 
    Row == 3; 
    Row == 4; 
    Row == 5; 
    Row == 6; 
    Row == 7; 
    Row == 8; 
    Row == 9;
    Row == 10) .

/*
* verify_move_choice(+Move, +Board, +Player)
* Se a escolha for 0, o jogador atual desiste e concede a vitória ao outro jogador (game_over).
* O terceiro argumento de game_over é uma lista com as jogadas possiveis, como Player desistiu a lista é vazia
*/
verify_move_choice(1, _, _).
verify_move_choice(2, _, _).
verify_move_choice(3, _, _).
verify_move_choice(4, _, _).
verify_move_choice(0, Board, Player) :-
    game_over(Board, Player, []).

/*
* code(+X, -Y) ou code(-X, +Y)
* Y é o número que representa internamente a coluna X 
*/
code('a', 0).
code('b', 1).
code('c', 2).
code('d', 3).
code('e', 4).
code('f', 5).
code('g', 6).
code('h', 7).
code('i', 8).
code('j', 9).

/*
* move_code(+X, -Y) ou move_code(-X, +Y)
* X é o número que representa internamente o movimento Y
*/
move_code(1, 'Right').
move_code(2, 'Left').
move_code(3, 'Up').
move_code(4, 'Down').

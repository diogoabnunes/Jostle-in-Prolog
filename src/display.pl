
/*
* display_game_name
* Imprime o nome do jogo: Jostle
*/
display_game_name :- nl,
	write('                       _______                              '), nl,
	write('                          |   ___    ___  __|__  |   ___      '), nl,    
	write('                          |  /   \\  /___    |    |  /___|     '), nl,
	write('                      \\___/  \\___/   ___/   |    |  \\___      '), nl,
	nl.

/*
* display_game_over
* Imprime a indicação do fim de jogo: Game Over
*/
display_game_over :-
	write('             ____                                ___                        '), nl,
	write('            /        __     __  __    ___       /   \\          ___     __   '), nl,    
	write('           |   __    __|  |/  |/  |  /___|     |     |  \\  /  /___|  |/     '), nl,
	write('            \\____|  |__|  |   |   |  \\___       \\___/    \\/   \\___   |      '), nl,
	nl.

/*
* display_player(+Player)
* Imprime o nome do jogador atual
*/
display_player(Player):-
	format('     Player: ~w', Player),nl.

/*
* display_winner(+Player)
* Imprime o nome do jogador vencedor
*/
display_winner(Player):-
	nl, format('                               WINNER: Player ~w ', Player), nl, nl, nl.

/*
* display_value(+Player, +Value)
* Imprime o nome e valor do jogador vencedor 
*/
display_value(Player, Value):-
	format('     Player ~w ', Player),
    format('value: ~w', Value), nl.

/*
* display_computer_play(+[Col,Row,Move])
* Imprime a jogada feita. A Col e Row da peça assim como Move, a direção do movimento.
*/
display_computer_play([Col,Row,Move]) :-
    RowTable is Row+1,
    code(ColCode, Col),
    move_code(Move, MoveCode),
    write('Column (a-j): '), write(ColCode), nl,
    write('Row (1-10): '), write(RowTable), nl,
    write('Move: '), write(MoveCode), nl.
    
/*
* display_board(+Board)
* Imprime o Tabuleiro do jogo 
*/
display_board(Board):-
   	printColumnIdentifiers, nl,
    printHorizontalSeparator, nl,
	print_matrix(Board).

printColumnIdentifiers:-
	write('                                a b c d e f g h i j').

printHorizontalSeparator:-
	write('                                ___________________ ').

print_matrix(Board):-
    print_matrix(Board,1).

print_matrix([],_).

print_matrix([H|T], N) :-
    print_line(H, N), nl,
    N1 is N+1,
    print_matrix(T, N1).

print_line(H, X) :-
	printRowId(X),
    format(' |~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|', H).

printRowId(X):-
    X > 9, !,     
    format('                            ~w', X).

printRowId(X):- 
    format('                             ~w', X).

/*
* display_game(+Board-Player-ValueV-ValueA)
* Imprime o Tabuleiro do jogo, o jogador atual, e os valores dos dois jogadores
*/
display_game(Board-Player-ValueV-ValueA) :-
    nl,nl,
    write('------------------------------------------------------------------------------'),nl,
    display_value('V', ValueV),
    display_value('A', ValueA),
    nl,display_board(Board), 	
    display_player(Player).

/*
* not_valid
* Imprime uma mensagem para indicar que a escolha não é válida
*/
not_valid :-
    nl, write('--NOT VALID, TRY AGAIN--').

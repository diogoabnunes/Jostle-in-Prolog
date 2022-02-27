:- [logic].

/*
* play
* Começar o jogo
*/
play :- 
    %repeat, 
    display_game_name,
    menu_game_mode, nl,
    read(Choice),
    Choice < 5,
    start(Choice).

/*
* start(+Choice)
* Iniciar o jogo em si de acordo com a Choice
*/
start(Choice) :- 
    Choice == 1, !,
    initial_state(Board,Player),
    game_pvp(Board, Player).

start(Choice) :- 
    Choice == 2, !, 
    initial_state(Board,Player),
    game_pvc(Board, Player).

start(Choice) :- 
    Choice == 3, !, 
    initial_state(Board,Player),
    game_cvp(Board, Player).

start(Choice) :-
    Choice == 4, !,
    initial_state(Board,Player),
    game_cvc(Board, Player).

start(Choice) :-
    Choice == 0,
    abort.

start(_) :-
    nl, write('--INVALID INPUT--'), nl,
    play.

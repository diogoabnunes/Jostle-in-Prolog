
:- [board].
:- use_module(library(random)).

/*
* verify_owner(+Board, +Col, +Row, +Player)
* Verifica que uma dada peça pertence a um dado jogador.
*/
verify_owner(Board, Col, Row, Player) :-
    get_cell(Board, Col, Row, Cell),   
    Cell == Player.

/*
* get_pos_after_move(+Col, +Row, +Move, -Mcol, -Mrow)
* Obtem em Mcol e Mrow a posição resultante do movimento, da peça em Col e Row, com direção Move.
*/
get_pos_after_move(Col, Row, Move, Mcol, Row):-
    Move == 1, !,
    Mcol is Col + 1,
    Mcol =< 10.
get_pos_after_move(Col, Row, Move, Mcol, Row):-
    Move == 2, !,
    Mcol is Col - 1,
    Mcol >= 0.
get_pos_after_move(Col, Row, Move, Col, Mrow):-
    Move == 3, !,
    Mrow is Row - 1,
    Mrow >= 0.
get_pos_after_move(Col, Row, Move, Col, Mrow):-
    Move == 4,
    Mrow is Row + 1,
    Mrow =< 10.
    
/*
* get_newBoard(+Board, +Player, +Col, +Row, +Mcol, +Mrow, -NewBoard)
* Substitui a peça na posição Col e Row pela célula vazia. Coloca na posição Mcol e Mrow a peça do jogador Player. NewBoard é o novo tabuleiro resultanate das alterações.
*/
get_newBoard(Board, Player, Col, Row, Mcol, Mrow, NewBoard):-
    replace_value_matrix(Board, Col, Row, ' ', TempBoard),
    replace_value_matrix(TempBoard, Mcol, Mrow, Player, NewBoard).

/*
* get_checker_points(+Board, +Col, +Row, -Points)
* Calcula o valor total de uma peça, tendo em conta todos os seus vizinhos.
*/
get_checker_points(Board, Col, Row, Points):-
    get_cell(Board, Col, Row, Cell),
    get_checker_points(Board, Col, Row, Cell, Points, 0, 1).

/*
* Chega a este predicado quando já todos os vizinhos foram visitados e contabilizados.
*/
get_checker_points(_, _, _, _, TempPoints, TempPoints, Move):-
    Move == 5, !.

/*
* Percorre todos os vizinhos (1 a 4, que corresponde às direções ortogonais possíveis)
*/
get_checker_points(Board, Col, Row, Cell, Points, TempPoints, Move):-
    get_pos_after_move(Col, Row, Move, Mcol, Mrow), !,
    get_cell(Board, Mcol, Mrow, NeighborCell),
    add_connection_points(Cell, NeighborCell, TempPoints, NeighborPoints),
    NextMove is Move + 1,
    get_checker_points(Board, Col, Row, Cell, Points, NeighborPoints, NextMove).

/*
* Percorre todos os vizinhos (1 a 4, que corresponde às direções ortogonais possíveis), no caso de get_cell_after_move falhar.
*/
get_checker_points(Board, Col, Row, Cell, Points, TempPoints, Move):-
    NextMove is Move + 1,
    get_checker_points(Board, Col, Row, Cell, Points, TempPoints, NextMove).

/*
* add_connection_points(+Cell, +NeighborCell, +TempPoints, -NeighborPoints)
* Conexão amigável (aumenta o número de pontos): acontece quando 2 peças ortogonalmente adjacentes são do mesmo jogador.
* Sem conexão (número de pontos mantém-se): acontece quando 1 peça não tem uma peça adjacente numa dada direção.
* Conexão inimiga (diminui o número de pontos): acontece quando 2 peças ortogonalmente adjacentes são de diferentes jogadores.
*/
add_connection_points(Cell, NeighborCell, TempPoints, NeighborPoints):-
    Cell == NeighborCell, !,
    NeighborPoints is TempPoints + 1.
add_connection_points(_, NeighborCell, TempPoints, TempPoints):-
    NeighborCell == ' ', !.
add_connection_points(_, _, TempPoints, NeighborPoints):-
    NeighborPoints is TempPoints - 1.

/*
* verify_points(+Points, +NewPoints)
* Verificação que uma jogada pode ser efetuada: esta só é possível caso o valor da peça aumente.
*/
verify_points(Points, NewPoints):-
    NewPoints > Points.

/*
* change_player(+Player, -NewPlayer)
* Mudança de jogador.
*/
change_player('V', 'A').
change_player('A', 'V').

/*
* verify_valid_play(+Board, +Player, +Col, +Row, +Move)
* Verifica que uma dada jogada pode ser efetuada.
*/
verify_valid_play(Board, Player, Col, Row, Move) :-
    verify_owner(Board, Col, Row, Player),
    get_pos_after_move(Col, Row, Move, Mcol, Mrow),
    verify_available(Board, Mcol, Mrow),
    get_newBoard(Board, Player, Col, Row, Mcol, Mrow, NewBoard),
    get_checker_points(Board, Col, Row, Points),
    get_checker_points(NewBoard, Mcol, Mrow, NewPoints),
    verify_points(Points, NewPoints).

/*
* get_next_possible_play(+Col, +Row, +Move, -NextCol, -NextRow, -NextMove)
* Predicado usado no cálculo de todas as jogadas válidas, com o objetivo de calcular a próxima jogada possível.
*/
get_next_possible_play(Col, Row, Move, Col, Row, NextMove):-
    Move < 4,
    NextMove is Move + 1.
get_next_possible_play(Col, Row, 4, NextCol, Row, 1):-
    Col < 9,
    NextCol is Col + 1.
get_next_possible_play(9, Row, 4, 0, NewRow, 1):-
    NewRow is Row + 1.

/*
* get_plays(-Plays)
* Plays é uma lista com todas as jogadas possíveis (válidas ou não).
*/
get_plays(Plays):-
    get_plays(0,0,1,Plays).

get_plays(_, 10, _, []).
get_plays(Col, Row, Move,[[Col,Row,Move]|Tplays]):-
    get_next_possible_play(Col, Row, Move, NextCol, NextRow, NextMove),
    get_plays(NextCol, NextRow, NextMove, Tplays).

/*
* valid_moves(+GameState, -ListOfMoves)
* ListOfMoves é uma lista de listas [Row, Col, Move] com todas as jogadas válidas de um dado jogador.
*/
valid_moves(Board-Player, Plays):-
    get_valid_plays(Board, Player, 0, 0, 1, Plays).

get_valid_plays(_, _, _, 10, _, []). % fora do tabuleiro
get_valid_plays(Board, Player, Col, Row, Move,[[Col,Row,Move]|Tplays]):-
    verify_valid_play(Board, Player, Col, Row, Move), !,
    get_next_possible_play(Col, Row, Move, NextCol, NextRow, NextMove),
    get_valid_plays(Board, Player, NextCol, NextRow, NextMove,Tplays).
get_valid_plays(Board, Player, Col, Row, Move, Tplays):- % não válida para o Player
    get_next_possible_play(Col, Row, Move, NextCol, NextRow, NextMove),
    get_valid_plays(Board, Player, NextCol, NextRow, NextMove,Tplays).

/*
* choose_move(+GameState, +Level, -Move)
* Escolhe uma jogada aleatória de todas as jogadas possíveis para o Player.
*/
choose_move(Board-Player, _, Play):-
    valid_moves(Board-Player, Plays),
    random_member(Play, Plays).

/*
* value(+GameState, +Player, -Value)
* Calcula o valor do estado de jogo atual para o jogador P.
*/
value(Board-_, P, Value) :-
    valid_moves(Board-P, Plays),
    length(Plays, Value).
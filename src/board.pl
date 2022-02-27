/*
* verify_available(+Board, +Col, +Row)
* Verifica que uma dada posição no Board, dada por Col e Row, está vazia (' ') e no caso de isto ser verdade significa que a célula está disponível.
*/
verify_available(Board, Col, Row) :-
    get_cell(Board, Col, Row, Cell), !,
    Cell == ' '.

get_cell(Board, Col, Row, Cell) :-
    get_cell(Board, Col, Row, 0, Cell).

get_cell([_|T], Col, Row, Counter, Cell):-
    Counter < Row,
    C is Counter + 1,
    get_cell(T, Col, Row, C, Cell).

get_cell([H|_], Col, Row, Counter, Cell):-
    Counter == Row,
    check_cell(H, Col, Cell).

check_cell([H|T], Col, Cell):-
    check_cell([H|T], Col, Cell, 0).

check_cell([_|T], Col, Cell, Counter):-
    Counter < Col, !,
    C is Counter + 1,
    check_cell(T, Col, Cell, C).

check_cell([H|_], Col, H, Counter):-
    Counter == Col.

/*
* replace_value_matrix(+Board, +Col, +Row, +Val, -NewBoard)
* Coloca Val numa dada posição no Board, dada por Col e Row, sendo que NewBoard é o tabuleiro resultante desta alteração.
*/
replace_value_matrix(Board, Col, Row, Val, NewBoard) :-
    replace_value_matrix(Board, Col, Row, Val, [], NewBoard, 0).

replace_value_matrix([H|T], Col, Row, Val, TmpList, NewBoard, Counter) :-
    Counter < Row,
    C is Counter + 1,
	concat(TmpList, [H], Tmp),
    replace_value_matrix(T, Col, Row, Val, Tmp, NewBoard, C).

replace_value_matrix([H|T], Col, Row, Val, TmpList, NewBoard, Counter) :-
    Counter == Row,
    replace_value_list(H, Col, Val, NewRow),
	concat(TmpList, [NewRow], Tmp1),
	concat(Tmp1, T, NewBoard). 

concat([], L, L).
concat([X|L1], L2, [X|L3]) :- concat(L1, L2, L3).

replace_value_list([H|T], Pos, Val, L):-
    replace_value_list([H|T], 0, Pos, Val, [], L).

replace_value_list([_H|T], Pos, Pos, Val, TmpList, L) :-
    concat(TmpList, [Val|T], L).

replace_value_list([H|T], Pos_Ini, Pos, Val, TmpList, L) :-
    Pos_Ini < Pos,
    I is Pos_Ini + 1,
    concat(TmpList, [H], Tmp),
    replace_value_list(T, I, Pos, Val, Tmp, L).

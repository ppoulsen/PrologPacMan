isGhost(g).
isGhost(6).
isGhost(r).

isValidMove(p).
isValidMove(f).
isValidMove(u).
isValidMove(m).

findSymbolRow([], Char, X) :- X is -1.
findSymbolRow([Char|_], Char, X) :- X is 0.
findSymbolRow([_|T], Char, X) :-
    findSymbolRow(T, Char, NewIndex),
    ( NewIndex == -1
      -> X is -1
      ;  X is NewIndex+1
    ).

findSymbolHelper([], Char, Position, Y) :- fail.
findSymbolHelper([H|T], Char, Solution, Y) :-
    findSymbolRow(H, Char, X),
    ( X @< 0
      -> NextY is Y+1, findSymbolHelper(T, Char, Solution, NextY)
      ; Solution = [X, Y]
    ).
    
findSymbol(Map, Char, Position) :-
    findSymbolHelper(Map, Char, Position, 0).

verifyPathReaches(Map, Start, End, []) :-
    nth0(0, Start, StartX),
    nth0(1, Start, StartY),
    nth0(0, End, EndX),
    nth0(1, End, EndY),
    StartX == EndX,
    StartY == EndY.
    
verifyPathReaches(Map, Start, End, [H|T]) :-
    nth0(0, Start, StartX),
    nth0(1, Start, StartY),
    ( H == u -> NextX is StartX, NextY is StartY - 1
    ; H == d -> NextX is StartX, NextY is StartY + 1
    ; H == l -> NextX is StartX - 1, NextY is StartY
    ; H == r -> NextX is StartX + 1, NextY is StartY
    ; fail
    ),
    nth0(NextY, Map, Row),
    nth0(NextX, Row, NextCell),
    isValidMove(NextCell),
    !,
    verifyPathReaches(Map, [NextX, NextY], End, T).


pathOfGhost(Map, Path) :-
    isGhost(G),
    findSymbol(Map, G, PositionOfGhost),
    findSymbol(Map, m, PositionOfPacman),
    verifyPathReaches(Map, PositionOfGhost, PositionOfPacman, Path).
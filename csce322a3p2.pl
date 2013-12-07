findSymbolRow([], Char, X) :- X is -1.
findSymbolRow([Char|_], Char, X) :- X is 0.
findSymbolRow([_|T], Char, X) :-
    findSymbolRow(T, Char, NewIndex),
    ( NewIndex == -1
      -> X is -1
      ;  X is NewIndex+1
    ).

findSymbolHelper([], Char, Position, Y) :-
    Position = [-1, -1].
findSymbolHelper([H|T], Char, Solution, Y) :-
    findSymbolRow(H, Char, X),
    ( X @< 0
      -> NextY is Y+1, findSymbolHelper(T, Char, Solution, NextY)
      ; Solution = [X, Y]
    ).
    
findSymbol(Map, Char, Position) :-
    findSymbolHelper(Map, Char, Position, 0).

pathOfGhost(Map, Path) :-
    findSymbol(Map, g, PositionOfGhost),
    findSymbol(Map, m, PositionOfPacman),
    write(PositionOfGhost), nl,
    write(PositionOfPacman), nl.
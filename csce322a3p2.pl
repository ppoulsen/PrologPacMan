:- module( csce322a3p2,
    [ pathOfGhost/2
    ]
).

isGhost(g).
isGhost(6).
isGhost(r).

isValidMove(p).
isValidMove(f).
isValidMove(u).
isValidMove(m).
isValidMove(g).
isValidMove(6).
isValidMove(r).

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

shortestPath(Map, PositionOfGhost, Success, ShortestPath) :-
    findall(Length-Path, (findPathStart(Map, PositionOfGhost, Success, Path), length(Path, Length)), All),
    keysort(All, [_-ShortestPath|_]).

findPathStart(Map, PositionOfGhost, Success, Path) :-
    findPath(Map, [PositionOfGhost], Success, [], Path).

findPath(Map, [Current|Past], Success, Memory, Path) :-
    move(Current, Next, Move),
    nth0(0, Next, NextX),
    nth0(1, Next, NextY),
    nth0(NextY, Map, Row),
    nth0(NextX, Row, NextCell),
    ( NextCell == Success
      -> reverse([Move|Memory], Path)
      ;  isValidMove(NextCell)
      -> \+ memberchk(Next, Past),
      findPath(Map, [Next,Current|Past], Success, [Move|Memory], Path)
      ; fail
    ).

move(Position, Next, Move) :-
    nth0(0, Position, StartX),
    nth0(1, Position, StartY),
    ( X is StartX - 1, Y is StartY, Move = l;
    X is StartX + 1, Y is StartY, Move = r;
    X is StartX, Y is StartY - 1, Move = d;
    X is StartX, Y is StartY + 1, Move = u) ,
    Next = [X, Y].

checkEqual([],[]).
checkEqual([H1|T1],[H2|T2]) :-
    H1 == H2,
    checkEqual(T1, T2).

pathOfGhost(Map, Path) :-
    isGhost(G),
    findSymbol(Map, G, PositionOfGhost),
    findSymbol(Map, m, PositionOfPacman),
    shortestPath(Map, PositionOfGhost, m, ShortestPath),
    ( ground(Path)
      -> checkEqual(ShortestPath, Path)
      ; Path = ShortestPath
    ).
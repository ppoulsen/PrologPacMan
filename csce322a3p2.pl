:- module( csce322a3p2,
    [ pathOfGhost/2,
      findSymbol/3,
      isValidMove/1
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

findSymbolRow([], _, X) :- X is -1.
findSymbolRow([Char|_], Char, X) :- X is 0.
findSymbolRow([_|T], Char, X) :-
    findSymbolRow(T, Char, NewIndex),
    ( NewIndex == -1
      -> X is -1
      ;  X is NewIndex+1
    ).

findSymbolHelper([], _, _, _) :- fail.
findSymbolHelper([H|T], Char, Solution, Y) :-
    findSymbolRow(H, Char, X),
    ( X @< 0
      -> NextY is Y+1, findSymbolHelper(T, Char, Solution, NextY)
      ; Solution = [X, Y]
    ).
    
findSymbol(Map, Char, Position) :-
    findSymbolHelper(Map, Char, Position, 0).

verifyPathReaches(_, Start, End, []) :-
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

getAllShortest([], _, ShortestPaths) :- ShortestPaths = [].
getAllShortest([Key-Value|T], ShortestLength, [H|T2]) :-
    Key == ShortestLength,
    H = Value,
    getAllShortest(T, ShortestLength, T2).
getAllShortest([Key-_|T], ShortestLength, ShortestPaths) :-
    Key \== ShortestLength,
    getAllShortest(T, ShortestLength, ShortestPaths).

returnAllPaths([], _) :- fail.
returnAllPaths([H|T], ShortestPath) :-
    (
      ShortestPath = H ;
      returnAllPaths(T, ShortestPath)
    ).

findShortestLength(All, ShortestLength) :-
    keysort(All, [ShortestLength-_|_]).

shortestPath(Map, PositionOfGhost, Success, ShortestPath) :-
    findall(Length-Path, (startTravelling(Map, PositionOfGhost, Success, Path), length(Path, Length)), All),
    findShortestLength(All, ShortestLength),
    getAllShortest(All, ShortestLength, ShortestPaths),
    returnAllPaths(ShortestPaths, ShortestPath).

startTravelling(Map, PositionOfGhost, Success, Path) :-
    travel(Map, [PositionOfGhost], Success, [], Path).

travel(Map, [Current|Past], Success, Memory, Path) :-
    generateAllMoves(Current, Next, Move),
    % Move will iterate through all possible moves and Next will be the next coordinate
    nth0(0, Next, NextX),
    nth0(1, Next, NextY),
    nth0(NextY, Map, Row),
    nth0(NextX, Row, NextCell),
    ( NextCell == Success
      -> reverse([Move|Memory], Path)
      ;  isValidMove(NextCell)
      -> \+ memberchk(Next, Past),
      travel(Map, [Next,Current|Past], Success, [Move|Memory], Path)
      ; fail
    ).

generateAllMoves(Position, Next, Move) :-
    nth0(0, Position, StartX),
    nth0(1, Position, StartY),
    (
     X is StartX - 1,
     Y is StartY,
     Move = l ;
     
     X is StartX + 1,
     Y is StartY,
     Move = r;
     
     X is StartX,
     Y is StartY - 1,
     Move = u;
     
     X is StartX,
     Y is StartY + 1,
     Move = d
    ),
    Next = [X, Y].

checkEqual([],[]).
checkEqual([H1|T1],[H2|T2]) :-
    H1 == H2,
    checkEqual(T1, T2).

pathOfGhost(Map, Path) :-
    isGhost(G),
    findSymbol(Map, G, PositionOfGhost),
    shortestPath(Map, PositionOfGhost, m, ShortestPath),
    ( ground(Path)
      -> checkEqual(ShortestPath, Path)
      ; Path = ShortestPath
    ).
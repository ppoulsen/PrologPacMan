:- use_module(csce322a3p1).
:- use_module(csce322a3p2).

allBorders([]).
allBorders([H|T]) :- H == b, allBorders(T).

isCell(b).
isCell(w).
isCell(f).
isCell(p).
isCell(m).
isCell(g).
isCell(6).
isCell(r).
isCell(u).

validCellsRow([]).
validCellsRow([H|T]) :- isCell(H), validCellsRow(T).

validCells([]).
validCells([H|T]) :-
  validCellsRow(H),
  validCells(T).

checkNoBordersInMid(_, LastCellIndex, LastCellIndex).
checkNoBordersInMid([H|T], CellIndex, LastCellIndex) :-
    (
     CellIndex == 0 ;
     CellIndex \= 0, H \== b
    ),
    NewCellInd is CellIndex + 1,
    checkNoBordersInMid(T, NewCellInd, LastCellIndex).

checkEdges([], _, _).
checkEdges([H|T], Index, LastRowIndex) :-
    nth0(0, H, FirstCell),
    length(H, CellCount),
    LastCellIndex is CellCount - 1,
    nth0(LastCellIndex, H, LastCell),
    ( Index == 0 ;
      Index == LastRowIndex ;
      Index \== 0,
      Index \== LastRowIndex,
      checkNoBordersInMid(H, 0, LastCellIndex),
      FirstCell == b,
      LastCell == b
    ),
    NewIndex is Index + 1,
    checkEdges(T, NewIndex, LastRowIndex).

checkBorders(Map) :-
    length(Map, Rowcount),
    nth0(0, Map, FirstRow),
    LastRowIndex is Rowcount - 1,
    nth0(LastRowIndex, Map, LastRow),
    allBorders(FirstRow),
    allBorders(LastRow),
    checkEdges(Map, 0, LastRowIndex).

checkRestOfRow(_, SndLstCellInd, SndLstCellInd).
checkRestOfRow([H|T], SndLstCellInd, Index) :-
    (
     Index == 1 ;
     Index \== 1, H \== p, H \== r
    ),
    NextIndex is Index + 1,
    checkRestOfRow(T, SndLstCellInd, NextIndex).

checkPowerCorner(Row) :-
    length(Row, Cellcount),
    nth0(1, Row, SecondCell),
    SndLstCellInd is Cellcount - 2,
    nth0(SndLstCellInd, Row, SndLastCell),
    ( SecondCell == p ; SecondCell == r ),
    ( SndLastCell == p ; SndLastCell == r),
    checkRestOfRow(Row, SndLstCellInd, 0).

noPowerCells([]).
noPowerCells([H|T]) :-
    H \== p,
    H \== r,
    noPowerCells(T).

checkNoOtherPowers(_, SndLastRowInd, SndLastRowInd).
checkNoOtherPowers([H|T], SndLastRowInd, Index) :-
    (
     Index == 1 ;
     Index \== 1, noPowerCells(H)
    ),
    NextIndex is Index + 1,
    checkNoOtherPowers(T, SndLastRowInd, NextIndex).
    
powerCells(Map) :-
    length(Map, Rowcount),
    nth0(1, Map, SecondRow),
    SndLstRowInd is Rowcount - 2,
    nth0(SndLstRowInd, Map, SndLastRow),
    checkPowerCorner(SecondRow),
    checkPowerCorner(SndLastRow),
    checkNoOtherPowers(Map, SndLstRowInd, 0).

shortestPath(Map, PositionOfMan, SuccessX, SuccessY, ShortestPath) :-
    findall(Length-Path, (findPathStart(Map, PositionOfMan, SuccessX, SuccessY, Path), length(Path, Length)), All),
    keysort(All, [_-ShortestPath|_]).

findPathStart(Map, PositionOfMan, SuccessX, SuccessY, Path) :-
    findPath(Map, [PositionOfMan], SuccessX, SuccessY, [], Path).

findPath(Map, [Current|Past], SuccessX, SuccessY, Memory, Path) :-
    move(Current, Next, Move),
    nth0(0, Next, NextX),
    nth0(1, Next, NextY),
    nth0(NextY, Map, Row),
    nth0(NextX, Row, NextCell),
    ( (NextX == SuccessX, NextY == SuccessY)
      -> reverse([Move|Memory], Path)
      ;  isValidMove(NextCell)
      -> \+ memberchk(Next, Past),
      findPath(Map, [Next,Current|Past], SuccessX, SuccessY, [Move|Memory], Path)
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

checkAllCellsRow(_, [], _, _, _).
checkAllCellsRow(Map, [H|T], PositionOfPacman, Col, Row) :-
    (
      H == b;
      H == w;
      H == m;
      H \== b, H \== w, H \== m, shortestPath(Map, PositionOfPacman, Col, Row, _)
    ),
    NextCol is Col + 1,
    checkAllCellsRow(Map, T, PositionOfPacman, NextCol, Row).

checkAllCells(_, [], _, _).
checkAllCells(Map, [H|T], PositionOfPacman, Row) :-
    checkAllCellsRow(Map, H, PositionOfPacman, 0, Row),
    NextRow is Row + 1,
    checkAllCells(Map, T, PositionOfPacman, NextRow).

reachableCells(Map) :-
    findSymbol(Map, m, PositionOfPacman),
    checkAllCells(Map, Map, PositionOfPacman, 0).

makeMap(Map) :-
    validCells(Map),
    percentWalls(Map),
    checkBorders(Map),
    powerCells(Map),
    reachableCells(Map).
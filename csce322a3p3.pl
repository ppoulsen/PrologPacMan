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

checkEdges([]).
checkEdges([H|T]) :-
    nth0(0, H, FirstCell),
    length(H, CellCount),
    LastCellIndex is CellCount - 1,
    nth0(LastCellIndex, H, LastCell),
    FirstCell == b,
    LastCell == b,
    checkEdges(T).

checkBorders(Map) :-
    length(Map, Rowcount),
    nth0(0, Map, FirstRow),
    LastRowIndex is Rowcount - 1,
    nth0(LastRowIndex, Map, LastRow),
    allBorders(FirstRow),
    allBorders(LastRow),
    checkEdges(Map).

checkPowerCorner(Row) :-
    length(Row, Cellcount),
    nth0(1, Row, SecondCell),
    SndLstCellInd is Cellcount - 2,
    nth0(SndLstCellInd, Row, SndLastCell),
    ( SecondCell == p ; SecondCell == r ),
    ( SndLastCell == p ; SndLastCell == r).
    
powerCells(Map) :-
    length(Map, Rowcount),
    nth0(1, Map, SecondRow),
    SndLstRowInd is Rowcount - 2,
    nth0(SndLstRowInd, Map, SndLastRow),
    checkPowerCorner(SecondRow),
    checkPowerCorner(SndLastRow).

makeMap(Map) :-
    validCells(Map),
    percentWalls(Map),
    checkBorders(Map),
    powerCells(Map).
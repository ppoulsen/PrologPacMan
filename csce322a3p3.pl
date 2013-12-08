:- use_module(csce322a3p1).
:- use_module(csce322a3p2).

allBorders([]).
allBorders([H|T]) :- H == b, allBorders(T).

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
    

makeMap(Map) :-
    percentWalls(Map),
    checkBorders(Map).
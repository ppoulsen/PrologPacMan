:- module( csce322a3p1,
    [ percentWalls/1
    ]
).

isBorder(b).
isWall(w).
isFood(f).
isPower(p).
isMan(m).
isGhost(g).
isGhostFood(6).
isGhostPower(r).
isEmpty(u).

wallCountRow([], RowCount) :- RowCount is 0.
wallCountRow([w|T], RowCount) :-
    wallCountRow(T, RemainingRowCount),
    RowCount is (1 + RemainingRowCount).
wallCountRow([_|T], RowCount) :-
    wallCountRow(T, RemainingRowCount),
    RowCount is RemainingRowCount.

wallCount([], WallCount) :- WallCount is 0.
wallCount([H|T], WallCount) :-
    wallCountRow(H, RowCount),
    wallCount(T, RestOfWallCount),
    WallCount is (RowCount + RestOfWallCount).

cellCountRow([], RowCount) :- RowCount is 0.
cellCountRow([_|T], RowCount) :-
    cellCountRow(T, RemainingRowCount),
    RowCount is (1 + RemainingRowCount).

cellCount([], CellCount) :- CellCount is 0.
cellCount([H|T], CellCount) :-
    cellCountRow(H, RowCount),
    cellCount(T, RestOfCellCount),
    CellCount is (RowCount + RestOfCellCount).

percentWallsCalc(Map, X) :-
    wallCount(Map, WallCount),
    cellCount(Map, CellCount),
    X is (float(WallCount) / float(CellCount)).

percentWalls(Map) :-
    percentWallsCalc(Map, X),
    !,
    X >= 0.10.
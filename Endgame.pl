% Example at the point
gridSize(5,5).
iAt(1,2,s0).
tAt(3,4).
sAt(1,1,1,0,s0).
sAt(2,2,1,0,s0).
sAt(3,2,2,0,s0).
sAt(4,3,3,0,s0).

%       0   1   2   3   4
%   0 |   |   |   |   |   |
%   1 |   | s | i |   |   |
%   2 |   | s | s |   |   |
%   3 |   |   |   | s | t |
%   4 |   |   |   |   |   |

% gridSize(2,2).
% iAt(0,0,s0).
% tAt(1,1).
% sAt(1,0,0,0,s0).
% sAt(2,1,0,0,s0).


sAt(ID,X,Y,1,SN):-
    (SN = result(A,S0),
    A = collect,
    sAt(ID,X,Y,0,s0),
    iAt(X,Y,S0));

    (SN = result(A,S0),
    sAt(ID,X,Y,1,S0)).


% Ironman At (X, Y, SN) exists there if he was already there, and there was stone there, and he collected it.
iAt(X,Y,SN):-
    (SN = result(A,S0),
    A = collect,
    iAt(X,Y,S0));

% Ironman at (X, Y, SN) exists there if he was on Y0 before which is at least one cell away from the borders (0-index),
% and he moved left.
    (SN = result(A,S0),
    A = left,
    iAt(X,Y0,S0),
    Y0 > 0,
    Y is Y0 - 1);


% Ironman at (X, Y, SN) exists there if he was on Y0 before which is at least one cell away from the borders (grid size),
% and he moved right.
    (SN = result(A,S0),
    A = right,
    iAt(X,Y0,S0),
    gridSize(_,GY),
    Y0 < GY - 1,
    Y is Y0 + 1);


% Ironman at (X, Y, SN) exists there if he was on X0 before which is at least one cell away from the borders (grid size),
% and he moved down.
    (SN = result(A,S0),
    A = down,
    iAt(X0,Y,S0),
    gridSize(GX,_),
    X0 < GX - 1,
    X is X0 + 1);


% Ironman at (X, Y, SN) exists there if he was on X0 before which is at least one cell away from the borders (0-index),
% and he moved up.
    (SN = result(A,S0),
    A = up,
    iAt(X0,Y,S0),
    X0 > 0,
    X is X0 - 1).


% Snap is performed if there exists a situation S0 previously where thanos and ironman at the same position.
% TODO check stones were collected!!
snapped1(S):-
    S = result(snap, S0),
    tAt(X, Y),
    iAt(X, Y, S0),
    sAt(1,_,_,1,S0),
    sAt(2,_,_,1,S0),
    sAt(3,_,_,1,S0),
    sAt(4,_,_,1,S0).



% Enforce an iterative deepening mechanism to enforce in turn completeness
generateLimit(1).
generateLimit(L):-
    generateLimit(O),
    O < 50,
    L is O + 1.

% snapped only if at some depth of a search tree there exists a snapped solution.
snapped(S):-
    generateLimit(L),
    call_with_depth_limit(snapped1(S),L,R),
    R \= depth_limit_exceeded,
    !.

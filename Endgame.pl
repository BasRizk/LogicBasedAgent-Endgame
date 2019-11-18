% Example at the point
gridSize(5,5).
iAt(1,2,s0).
tAt(3,4).
sAt(1,1,s0).
sAt(2,1,s0).
sAt(2,2,s0).
sAt(3,3,s0).

%       0   1   2   3   4
%   0 |   |   |   |   |   |
%   1 |   | s | i |   |   |
%   2 |   | s | s |   |   |
%   3 |   |   |   | s | t |
%   4 |   |   |   |   |   |

% gridSize(2,2).
% iAt(0,0,s0).
% tAt(1,1).


%  Defined Operators
action(up).
action(down).
action(left).
action(right).
action(collect).

% Output form to follow successor state axioms
result(A,s0):-
    action(A).

result(A,S):-
    action(A),
    S = result(_,_).

% Stone At (X, Y, S2) exists there if it was already there and was not collected before.
sAt(X,Y,SN):-
    SN = result(A,S0),
    sAt(X,Y,S0),
    action(A),
    A \= collect.

% Ironman At (X, Y, SN) exists there if he was already there, and there was stone there, and he collected it.
iAt(X,Y,SN):-
    SN = result(A,S0),
    iAt(X,Y,S0),
    sAt(X,Y,S0),
    A = collect.

% Ironman at (X, Y, SN) exists there if he was on Y0 before which is at least one cell away from the borders (0-index),
% and he moved left.
iAt(X,YN,SN):-
    SN = result(A,S0),
    iAt(X,Y0,S0),
    Y0 > 0,
    YN is Y0 - 1,
    action(A),
    iAt(X, YN, SN),
    A = left.

% Ironman at (X, Y, SN) exists there if he was on Y0 before which is at least one cell away from the borders (grid size),
% and he moved right.
iAt(X,YN,SN):-
    SN = result(A,S0),
    iAt(X,Y0,S0),
    gridSize(_,GY),
    Y0 < GY - 1,
    YN is Y0 + 1,
    action(A),
    A = right.

% Ironman at (X, Y, SN) exists there if he was on X0 before which is at least one cell away from the borders (grid size),
% and he moved down.
iAt(XN,Y,SN):-
    SN = result(A,S0),
    iAt(X0,Y,S0),
    gridSize(GX,_),
    X0 < GX - 1,
    XN is X0 + 1,
    action(A),
    A = down.

% Ironman at (X, Y, SN) exists there if he was on X0 before which is at least one cell away from the borders (0-index),
% and he moved up.
iAt(XN,Y,SN):-
    SN = result(A,S0),
    iAt(X0,Y,S0),
    X0 > 0,
    XN is X0 - 1,
    action(A),
    A = up.

% Snap is performed if there exists a situation S0 previously where thanos and ironman at the same position.
% TODO check stones were collected!!
snapped1(S):-
    S = result(snap, S0),
    tAt(X, Y),
    iAt(X, Y, S0).


% Enforce an iterative deepening mechanism to enforce in turn completeness
generateLimit(10).
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

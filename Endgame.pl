% Example 1
% 
% gridSize(5,5).
% tAt(3,4).
% sAt(1,1,1,s0).
% sAt(2,2,1,s0).
% sAt(3,2,2,s0).
% sAt(4,3,3,s0).
% iAt(1,2,s0).

%       0   1   2   3   4
%   0 |   |   |   |   |   |
%   1 |   | s | i |   |   |
%   2 |   | s | s |   |   |
%   3 |   |   |   | s | t |
%   4 |   |   |   |   |   |


% EXAMPLE 2
% 
% gridSize(5,5).
% tAt(4,2).
% sAt(1,4,0,s0).
% sAt(2,1,2,s0).
% sAt(3,3,0,s0).
% sAt(4,2,1,s0).
% iAt(2,2,s0).


%       0   1   2   3   4
%   0 |   |   |   |   |   |
%   1 |   |   | s |   |   |
%   2 |   | s | i |   |   |
%   3 | s |   |   |   |   |
%   4 | s |   | t |   |   |

% Example 3 (Simple)
% 
% gridSize(2,2).
% iAt(0,0,s0).
% tAt(1,1).
% sAt(1,0,0,s0).
% sAt(2,1,0,s0).

% Ironman At (X, Y, SN) exists there if he was already there, and he performed the collect action,
% Or, he was in a neighbor cell in the previous and he performed a move action that got him to the current cell.
iAt(X,Y,result(A, S0)):-
    (A = collect,
    iAt(X,Y,S0));

    (A = left,
    iAt(X,Y0,S0),
    Y0 > 0,
    Y is Y0 - 1);

    (A = right,
    iAt(X,Y0,S0),
    gridSize(_,GY),
    Y0 < GY - 1,
    Y is Y0 + 1);

    (A = down,
    iAt(X0,Y,S0),
    gridSize(GX,_),
    X0 < GX - 1,
    X is X0 + 1);

    (A = up,
    iAt(X0,Y,S0),
    X0 > 0,
    X is X0 - 1).

% In a state "SN", A stone was collected before in position (X,Y) if and only if
% A "collect" action was performed in the previous state "S0" and Ironman was at (X,Y), where the stone exists and was not collected before.
% Or, in "S0", the stone was collected before.
stoneExists(ID, X, Y, 0, s0):-
    sAt(ID, X, Y, s0).

stoneExists(ID,X,Y,1,result(A,S0)):-
    (A = collect,
    stoneExists(ID,X,Y,0,s0),
    iAt(X,Y,S0));

    stoneExists(ID,X,Y,1,S0).


% Snap is performed if there exists a situation S0 previously where thanos and ironman at the same position.
snapped1(result(snap, S0)):-
    tAt(X, Y),
    iAt(X, Y, S0),
    stoneExists(1,_,_,1,S0),
    stoneExists(2,_,_,1,S0),
    stoneExists(3,_,_,1,S0),
    stoneExists(4,_,_,1,S0).

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
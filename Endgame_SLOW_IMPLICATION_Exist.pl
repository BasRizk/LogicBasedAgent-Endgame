:- use_module(library(clpfd)).

% Example at the point

gridSize(5,5).
sAt(1,1).
sAt(2,1).
sAt(2,2).
sAt(3,3).
tAt(3,4).
iAt(1,2, s0).

%       0   1   2   3   4
%   0 |   |   |   |   |   |
%   1 |   | s | i |   |   |
%   2 |   | s | s |   |   |
%   3 |   |   |   | s | t |
%   4 |   |   |   |   |   |

% Successful Example could be:
%%%%%%%%%% PASSING %%%%%%%
% Only sAt(2,2)
% result(snap, result(right, result(right, result(down, result(collect, result(down, s0))))))

% gridSize(5,5).
% sAt(4,0).
% sAt(1,2).
% sAt(3,0).
% sAt(2,1).
% tAt(4,2).
% iAt(2,2,s0).


%       0   1   2   3   4
%   0 |   |   |   |   |   |
%   1 |   |   | s |   |   |
%   2 |   | s | i |   |   |
%   3 | s |   |   |   |   |
%   4 | s |   | t |   |   |

% Ironman at (X, Y, SN) exists there if he was on Y0 before which is at least one cell away from the borders (0-index),
% and he moved left.
iAt(X,Y,result(A,S)):-
    (
        (
            (A = collect,
            stoneExists(X, Y, S),
            iAt(X, Y, S)
            );
            
            (A = left,
            iAt(X,Y0,S),
            not(stoneExists(X,Y0, S)),
            Y0 > 0,
            Y is Y0 - 1
            );
            
            (A = right,
            iAt(X,Y0,S),
            not(stoneExists(X,Y0, S)),
            gridSize(_,GY),
            Y0 < GY - 1,
            Y is Y0 + 1
            );

            (A = down,
            iAt(X0,Y,S),
            not(stoneExists(X0,Y, S)),
            gridSize(GX,_),
            X0 < GX - 1,
            X is X0 + 1
            );

            (A = up,
            iAt(X0,Y,S),
            not(stoneExists(X0,Y, S)),
            X0 > 0,
            X is X0 - 1
            )
                    
        )
        ;
        ( 
            iAt(X, Y, S),
            (
                (A = collect -> stoneExists(X, Y, S), not(stoneExists(X,Y, result(collect, S)))),
                ((A = left; A = right; A = down; A = up) -> gridSize(H, W), (X > H; X < 0; Y > W; Y < 0))
            )
        )
    )
    % , print(A), print(" "),
    % print(X), print(", "), print(Y), nl
    . 


%  Defined Operators
action(collect).
action(up).
action(down).
action(left).
action(right).

% In a state "SN", A stone was collected before in position (X,Y) if and only if
% A "collect" action was performed in the previous state "S0" and Ironman was at (X,Y), where the stone exists and was not collected before.
% Or, in "S0", the stone was collected before.
% stoneExists(ID, X, Y, 0, s0):-
%     sAt(ID, X, Y, 0, s0).


stoneExists(X, Y, s0):-
    sAt(X,Y).
stoneExists(X, Y, result(A, S)):-
    sAt(X, Y),
    (
            stoneExists(X, Y, S), 
            (
                (iAt(X,Y,S), action(A), A \= collect);
                (iAt(W, V, S), (W\=X; V\=Y), action(A), ( A \= collect; stoneExists(W, V, S)))
            )
            ;
            (
                stoneExists(X,Y,S),
                (
                    A = collect -> (iAt(W, V, S), (W\=X; V\=Y), stoneExists(W, V, S))
                % , print("Stone exists there"), nl)
                )
            )
    ).

% Enforce an iterative deepening mechanism to enforce in turn completeness
generateLimit(1).
generateLimit(L):-
    generateLimit(O),
    O < 50,
    L is O + 1.

% Snap is performed if there exists a situation S0 previously where thanos and ironman at the same position.
snap(result(snap, S)):-  
    tAt(X, Y), iAt(X, Y, S).

% snapped only if at some depth of a search tree there exists a snapped solution.
snapped(PLAN):-
    PLAN = result(snap, S0),
    generateLimit(L),
    call_with_depth_limit(snap(PLAN),L,R),
    not(stoneExists(_,_,S0)),
    R \= depth_limit_exceeded,
    !.
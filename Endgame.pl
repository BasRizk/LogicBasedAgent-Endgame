:- use_module(library(clpfd)).

% Example at the point

gridSize(5,5).
% sAt(1,1).
% sAt(2,1).
sAt(2,2).
% sAt(3,3).
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
%%%%%%%%%% INCORRECT BUT PASSING EXAMPLE
% result(snap, result(right, result(left, result(right, result(left, result(right, result(right, result(down, result(down, s0))))))))).
%  


% gridSize(2,2).
% iAt(0,0,s0).
% tAt(1,1).


%  Defined Operators
action(collect).
action(snap).
action(up).
action(down).
action(left).
action(right).


% notSnappedAlready(s0).
% notSnappedAlready(result(A, _)):-
%     action(A), A \= snap.

% Constraint positions to the grid size
% allowedPos(X,Y):-
%     gridSize(H, W),
%     X #>= 0, X #< H,
%     Y #>= 0, Y #< W.

% Stone At (X, Y, S) exists there if it was already there and was not collected before.
% sAt(X, Y, result(A1, S1)):-
%     allowedPos(X,Y),
%     % Effect
%     (S1 #= s0, iAt(X, Y, S1), action(A1), A1 #\= collect);
%     (S1 #= s0, iAt(W, Z, S1), allowedPos(W,Z), (W#\=X; Z#\=Y) , action(A1));
%     (S1 #= result(A0, _), action(A0), iAt(X, Y, S1), action(A1), A1 #\= collect);
%     (S1 #= result(A0, _), action(A0), iAt(W, Z, S1), (W#\=X; Z #\=Y) , action(A1));
%     % Presistance
%     (sAt(X, Y, S1),
%         (
%             (S1 #= s0, iAt(X, Y, S1) -> action(A1), A1 #\= collect),
%             (S1 #= s0, iAt(W, Z, S1), allowedPos(W,Z), (W#\=X; Z#\=Y), action(A1)),
%             (S1 #= result(A0, _), iAt(X, Y, S1) -> action(A1), A1 #\= collect),
%             (S1 #= result(A0, _), iAt(W, Z, S1), allowedPos(W,Z), (W#\=X; Z#\=Y), action(A0))
%         )
%     ).
    
% (S1 = s0, sAt(X, Y, S1), iAt(X, Y, S1) -> action(A1), A1 \= collect, print("Case 2"), nl);
% (S1 = s0, sAt(X, Y, S1), iAt(W, Z, S1), (W\=X; Z \=Y) , action(A1), print("Case 4"), nl);
% (S1 = result(A0, _), sAt(X, Y, S1), action(A0), iAt(X, Y, S1) -> action(A1), A1 \= collect, print("Case 1"), nl);
% (S1 = result(A0, _), sAt(X, Y, S1), action(A0), not(iAt(X, Y, S1)), action(A1), print("Case 3"), nl).

% sAt(ID,X,Y,1,result(collect,_)):-
%     sAt(ID,X,Y,0,s0).

% iAt(X,Y,result(collect,S0)):-
%     sAt(ID,X,Y,0,s0),
%     sAt(ID,X,Y,1,result(collect,S0)),
%     iAt(X,Y,S0).

% Ironman at (X, Y, SN) exists there if he was on Y0 before which is at least one cell away from the borders (0-index),
% and he moved left.
iAt(X,Y,result(A,S)):-
    (
        (
            (A = collect, 
            % print("STATE -> COLLECT"), nl,
            iAt(X, Y, S),
            % print("POS IN PLACE"), nl,
            stoneExists(X, Y, S),
            not(stoneExists(X, Y, result(collect, S)))
            % ,print("STONE IN PLACE"), nl
            % ,print(S), nl
            );
            
            (A = left,
            iAt(X,Y0,S),
            % not(stoneExists(X,Y0, S)),
            Y0 > 0,
            Y is Y0 - 1
            );
            
            (A = right,
            iAt(X,Y0,S),
            % not(stoneExists(X,Y0, S)),
            gridSize(_,GY),
            Y0 < GY - 1,
            Y is Y0 + 1
            );

            (A = down,
            iAt(X0,Y,S),
            % not(stoneExists(X0,Y, S)),
            gridSize(GX,_),
            X0 < GX - 1,
            X is X0 + 1
            );

            (A = up,
            iAt(X0,Y,S),
            % not(stoneExists(X0,Y, S)),
            X0 > 0,
            X is X0 - 1
            )
                    
        );
        ( 
            iAt(X, Y, S),
            (
                (A = collect -> stoneExists(X, Y, S), not(stoneExists(X,Y, result(collect, S))) ),
                ((A = left; A = right; A = down; A = up) -> gridSize(H, W), (X > H; X < 0; Y > W; Y < 0))
            )
        )
    )
    % , print(A), print(" "),
    % print(X), print(", "), print(Y), nl
    . 
    
stoneExists(X, Y, s0):-
    sAt(X,Y).
stoneExists(X, Y, result(A, S)):-
    stoneExists(X, Y, S), 
    ( (not(iAt(X, Y, S)), action(A)); (iAt(X,Y,S), action(A), A \= collect) );
    (
        stoneExists(X,Y,S),
        (
            A = collect -> (iAt(W, V, S), (W\=X; V\=Y), stoneExists(W, V, S), print("Stone exists there"), nl)
        )
    ).

% collectStone(X, Y, result(A, S)):-
%     (A = collect, sAt(X, Y), iAt(X, Y, S));
%     (collectStone(X, Y, S),
%         (
%             (A = collect, iAt(X, Y, S) -> sAt(X, Y) );
%             (A = collect, iAt(W, V, S), (W\=X; V\=Y) -> sAt(W, V))
%         )
%     ).

% Snap is performed if there exists a situation S0 previously where thanos and ironman at the same position.
snap(result(snap, S)):-  
    (tAt(X, Y), iAt(X, Y, S), print("allocated plan"), nl, not(stoneExists(_,_,S)), print("no stones should exist anymore") )
    % (snap(S),
    %     (
    %         % (iAt(X, Y, S) -> tAt(X, Y), not(stoneExists(_,_,S))),
    %         print("HERE WE ARE");
    %         (tAt(X, Y) -> iAt(W, V, S), (W\=X; V\=Y))
    %         % (tAt(X, Y) -> i)
    %     )
    % )
    .

% Ironman At (X, Y, SN) exists there if he was already there, and there was stone there, and he collected it.
% iAt(X, Y, result(collect, S)):-
%     % print("Effect"), nl,
%     (sAt(X, Y), iAt(X, Y, S));
%     % print("Presistance"), nl,
%     (
%     iAt(X, Y, S),
%         (
%             (iAt(X, Y, S) -> sAt(X, Y) );
%             (iAt(W, V, S), (W\=X; V\=Y) -> sAt(W, V))
%         )
%     ).

% Enforce an iterative deepening mechanism to enforce in turn completeness
generateLimit(10).
generateLimit(L):-
    generateLimit(O),
    O < 50,
    L is O + 1.

% snapped only if at some depth of a search tree there exists a snapped solution.
snapped(PLAN):-
    PLAN = result(snap,_),
    generateLimit(L),
    call_with_depth_limit(snap(PLAN),L,R),
    R \= depth_limit_exceeded,
    !.

gridSize(5,5).
iAt(1,2,s0).
tAt(3,4).
sAt(1,1,s0).
sAt(2,1,s0).
sAt(2,2,s0).
sAt(3,3,s0).


action(up).
action(down).
action(left).
action(right).
action(collect).


result(A,s0):-
    action(A).

result(A,S):-
    action(A),
    S = result(_,_).

iAt(X,Y,SN):-
    iAt(X,Y,SO),
    sAt(X,Y,SO)
    SN = result(A,SO),
    A = collect.

iAt(X,YN,SN):-
    iAt(X,YO,SO),
    YO >= 0,
    YN is YO - 1,
    action(A),
    SN = result(A,SO),
    A = left.
iAt(X,YN,SN):-
    gridSize(GX,GY),
    iAt(X,YO,SO),
    YO < GY - 1,
    YN is YO + 1,
    action(A),
    SN = result(A,SO),
    A = right.
iAt(XN,Y,SN):-
    gridSize(GX,GY),
    iAt(XO,Y,SO),
    XO < GY - 1,
    XN is XO + 1,
    action(A),
    SN = result(A,SO),
    A = down.
iAt(XN,Y,SN):-
    iAt(XO,Y,SO),
    XO >= 0,
    XN is XO - 1,
    action(A),
    SN = result(A,SO),
    A = up.


sAt(X,Y,SN):-
    SN = result(A,SO),
    sAt(X,Y,SO),
    A \= action(collect).


snapped1(S):-
    S = result(snap, SO),
    tAt(X,Y),
    iAt(X,Y,SO).


generateLimit(10).
generateLimit(L):-
    generateLimit(O),
    O < 50,
    L is O + 1.


snapped(S):-
    generateLimit(L),
    call_with_depth_limit(snapped1(S),L,_),
    R \= depth_limit_exceeded,
    !.

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
    SN = result(A,SO),
    A \= action(left), A \= action(up), A \= action(right), A \= action(down).

iAt(X,YN,SN):-
    iAt(X,YO,SO),
    YO is YN - 1,
    action(A),
    SN = result(A,SO),
    A = left.
iAt(X,YN,SN):-
    iAt(X,YO,SO),
    YO is YN - 1,
    action(A),
    SN = result(A,SO),
    A = down.
iAt(X,YN,SN):-
    iAt(X,YO,SO),
    YO is YN - 1,
    action(A),
    SN = result(A,SO),
    A = down.
iAt(X,YN,SN):-
    iAt(X,YO,SO),
    YO is YN - 1,
    action(A),
    SN = result(A,SO),
    A = down.


sAt(X,Y,SN):-
    SN = result(A,SO),
    A \= action(collect).


snapped(S):-
    S = result(snap, SO).
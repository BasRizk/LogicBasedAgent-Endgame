result(left, s0).
result(right, s0).
result(up, s0).
result(down, s0).
result(collect, s0).


result(left, S):-
    gridSize(X,Y),
    iAt(IX,IY),
    IY < Y, IY > 0,

    S = result(A, X),
    X =
    

snapped(S):-
    state(S, iAt(X,Y), tAt(X,Y), sAt(1,1,_,_), sAt(2,1,_,_), sAt(3,1,_,_), sAt(4,1,_,_)),
    S = result(snap, A),
    A = result(A, Y).
%%%% Artificial intelligence: choose in a Plateau the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:

initIndex(TaillePlateau) :-
	(not(indexAction(_,_));retractall(indexAction)),
    indexAction(1,-TaillePlateau), %Haut
    indexAction(2, TaillePlateau), %Bas
    indexAction(3,1),              %Droite
    indexAction(4,-1),             %Gauche
    indexAction(5,0),              %PasBouger
    indexAction(6,0).              %Bombe

posSafe(Pos, Plateau, TaillePlateau) :-
    (nth0(Pos+1, Plateau, Case), not(Case==2)),
    (nth0(Pos-1, Plateau, Case), not(Case==2)),
    (nth0(Pos+TaillePlateau, Plateau, Case), not(Case==2)),
    (nth0(Pos-TaillePlateau, Plateau, Case), not(Case==2)),
    ((nth0(Pos+1, Plateau, Case), Case==1); (nth0(Pos+2, Plateau, Case), not(Case==2))),
    ((nth0(Pos-1, Plateau, Case), Case==1); (nth0(Pos-2, Plateau, Case), not(Case==2))),
    ((nth0(Pos+TaillePlateau, Plateau, Case), Case==1); (nth0(Pos+TaillePlateau, Plateau, Case), not(Case==2))),
    ((nth0(Pos-TaillePlateau, Plateau, Case), Case==1); (nth0(Pos-TaillePlateau, Plateau, Case), not(Case==2))).

posAdjacentesPossibles(Pos, Board, TaillePlateau, )

posAdjacentesSafe([], posSafes). % condition de sortie : on a teste toutes les positions adjacentes possibles
testPosAdjacentes([X|ListeIndex], PosSafes) :- testPosAdjacentes(ListeIndex, Liste),posSafe(a,b,c), append(PosSafes, [X]). % la position adjacente est safe
testPosAdjacentes([X|ListeIndex], PosSafes) :- testPosAdjacentes(ListeIndex,PosSafes). % la position adjacente n'est pas safe



% iav1 : fait tout de maniere random
ia(Plateau, PosIndex, NewPosIndex, iav1) :- repeat, Move is random(7), indexAction(Move, I), NewPosIndex is PosIndex+I, nth0(NewPosIndex, Plateau, Elem), Elem==0, !.

<<<<<<< HEAD
% iav2 : detecte et evite les zones de danger des bombes et bouge de maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, NewPosIndex, TaillePlateau, iav2) :-
    repeat, (posSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board, TaillePlateau);
            Move is random(5),index(Move, I), NewPosIndex is PosIndex+I),
    nth0(NewPosIndex, Board, Elem), Elem==0, !.

% iav3 : detecte et evite les zones de danger et cherche si un
% deplacement peut la mettre en securite
ia(Board, PosIndex, NewPosIndex, TaillePlateau, iav3) :-
    repeat, (posSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board, TaillePlateau);
            Move is random(5),index(Move, I), NewPosIndex is PosIndex+I), testPosAdjacentes(PosAdjacentesPossibles, PosAdjacentesSafes),
    nth0(NewPosIndex, Board, Elem), Elem==0, !.
=======
% iav2 : detecte les zones de danger des bombes et bouge de maniere random tant qu'elle n'est pas sortie
ia(Plateau, PosIndex, NewPosIndex, TaillePlateau, iav2) :- repeat, (posSafe(PosIndex, Plateau, TaillePlateau) -> repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Plateau, TaillePlateau); Move is random(5),indexAction(Move, I), NewPosIndex is PosIndex+I), nth0(NewPosIndex, Plateau, Elem), Elem==0, !.
>>>>>>> 4275483efa7b2e7c5036c7a8d7d9d6a48a376b1d


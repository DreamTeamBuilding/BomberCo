%%%% Artificial intelligence: choose in a Plateau the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:

initIndex(TaillePlateau) :-
	(not(indexAction(_,_));retractall(indexAction)),
    assert(indexAction(1,-TaillePlateau)), %Haut
    assert(indexAction(2, TaillePlateau)), %Bas
    assert(indexAction(3,1)),              %Droite
    assert(indexAction(4,-1)),             %Gauche
    assert(indexAction(5,0)),              %PasBouger
    assert(indexAction(6,0)).              %Bombe 

posSafe(Pos, Plateau, TaillePlateau) :-
    (nth0(Pos+1, Plateau, Case), not(Case==2)),
    (nth0(Pos-1, Plateau, Case), not(Case==2)),
    (nth0(Pos+TaillePlateau, Plateau, Case), not(Case==2)),
    (nth0(Pos-TaillePlateau, Plateau, Case), not(Case==2)),
    ((nth0(Pos+1, Plateau, Case), Case==1); (nth0(Pos+2, Plateau, Case), not(Case==2))),
    ((nth0(Pos-1, Plateau, Case), Case==1); (nth0(Pos-2, Plateau, Case), not(Case==2))),
    ((nth0(Pos+TaillePlateau, Plateau, Case), Case==1); (nth0(Pos+TaillePlateau, Plateau, Case), not(Case==2))),
    ((nth0(Pos-TaillePlateau, Plateau, Case), Case==1); (nth0(Pos-TaillePlateau, Plateau, Case), not(Case==2))).


% iav1 : fait tout de maniere random
ia(Plateau, PosIndex, NewPosIndex, iav1) :- repeat, Move is random(7), indexAction(Move, I), NewPosIndex is PosIndex+I, nth0(NewPosIndex, Plateau, Elem), Elem==0, !.

% iav2 : detecte les zones de danger des bombes et bouge de maniere random tant qu'elle n'est pas sortie
ia(Plateau, PosIndex, NewPosIndex, TaillePlateau, iav2) :- repeat, (posSafe(PosIndex, Plateau, TaillePlateau) -> repeat, Move is random(7),indexAction(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Plateau, TaillePlateau); Move is random(5),indexAction(Move, I), NewPosIndex is PosIndex+I), nth0(NewPosIndex, Plateau, Elem), Elem==0, !.


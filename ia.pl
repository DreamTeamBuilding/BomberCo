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

posAdjacentes(Pos, TaillePlateau, [Haut, Gauche, Droite, Bas]) :- Haut is Pos-TaillePlateau, Gauche is Pos-1, Droite is Pos+1, Bas is Pos + TaillePlateau.

isSafe(Pos, Plateau, TaillePlateau) :-
    (nth0(Pos+1, Plateau, Case), not(Case==2)),
    (nth0(Pos-1, Plateau, Case), not(Case==2)),
    (nth0(Pos+TaillePlateau, Plateau, Case), not(Case==2)),
    (nth0(Pos-TaillePlateau, Plateau, Case), not(Case==2)),
    ((nth0(Pos+1, Plateau, Case), Case==1); (nth0(Pos+2, Plateau, Case), not(Case==2))),
    ((nth0(Pos-1, Plateau, Case), Case==1); (nth0(Pos-2, Plateau, Case), not(Case==2))),
    ((nth0(Pos+TaillePlateau, Plateau, Case), Case==1); (nth0(Pos+TaillePlateau, Plateau, Case), not(Case==2))),
    ((nth0(Pos-TaillePlateau, Plateau, Case), Case==1); (nth0(Pos-TaillePlateau, Plateau, Case), not(Case==2))).

posAdjacentesPossibles(_,[],_).
posAdjacentesPossibles(Board, [X|L], PAP) :- posAdjacentesPossibles(Board, L, NewPAP), append(PAP,[X],NewPAP), nth0(X, Board, Case), Case==0.

posAdjacentesSafe([],_,_,_). % condition de sortie : on a teste toutes les positions adjacentes possibles
posAdjacentesSafe([X|ListeIndex],Plateau,TaillePlateau, PosSafes) :- posAdjacentesSafe(ListeIndex,Plateau,TaillePlateau,NewPosSafes),isSafe(X,Plateau,TaillePlateau), append(PosSafes, [X], NewPosSafe). % la position adjacente est safe
posAdjacentesSafe([X|ListeIndex], PosSafes) :- testPosAdjacentes(ListeIndex,PosSafes). % la position adjacente n'est pas safe



% iav1 : fait tout de maniere random
ia(Plateau, PosIndex, NewPosIndex, iav1) :- repeat, Move is random(7), indexAction(Move, I), NewPosIndex is PosIndex+I, nth0(NewPosIndex, Plateau, Elem), Elem==0, !.

% iav2 : detecte et evite les zones de danger des bombes et bouge de maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, NewPosIndex, TaillePlateau, iav2) :-
    repeat, (isSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),indexAction(Move, I), NewPosIndex is PosIndex+I, isSafe(NewPosIndex, Board, TaillePlateau);
            Move is random(5),indexAction(Move, I), NewPosIndex is PosIndex+I),
    nth0(NewPosIndex, Board, Elem), Elem==0, !.

% iav3 : detecte et evite les zones de danger et cherche si un
% deplacement peut la mettre en securite
ia(Board, PosIndex, NewPosIndex, TaillePlateau, iav3) :-
    repeat, (isSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),indexAction(Move, I), NewPosIndex is PosIndex+I, isSafe(NewPosIndex, Board, TaillePlateau), nth0(NewPosIndex, Board, Elem), Elem==0; % si en dehors de zone de danger : random
            posAdjacentes(PosIndex, TaillePlateau, PosAdjacentes), posAdjacentesPossibles(Board, PosAdjacentes, PosAdjacentesPossibles),  % dans zone de danger : on regarde quelles positions adjacentes sont safe
	     posAdjacentesSafe(PosAdjacentesPossibles, Board, TaillePlateau, PosAdjacentesSafes),
	     % si PosAdjacentesSafes est vide : piocher dans PosAdjacentesPossibles
	     ((length(PosAdjacentesPossibles,0)) ->
	     random_member(NewPosIndex, posAdjacentes);
	     random_member(NewPosIndex, PosAdjacentesSafes))),
    !.

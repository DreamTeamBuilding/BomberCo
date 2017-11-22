%%%% Artificial intelligence: choose in a Plateau the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:

initIndex(TaillePlateau) :-
	(not(indexAction(_,_,_));retractall(indexAction(_,_,_))),
    assert(indexAction(1,-TaillePlateau,0)), %Haut
    assert(indexAction(2, TaillePlateau,0)), %Bas
    assert(indexAction(3,1,0)),              %Droite
    assert(indexAction(4,-1,0)),             %Gauche
    assert(indexAction(5,0,0)),              %PasBouger
    assert(indexAction(6,0,1)).              %Bombe

isSafe(Pos, Plateau, TaillePlateau) :-  % la case a l'index Pos est safe ?
    (not(bombes(Pos, Temps)); Temps >= 5), % bombe sur le joueur
    (not(bombes(Pos+1, Temps)); Temps >= 4), % bombe a droite
    (not(bombes(Pos-1, Temps)); Temps >= 4), % bombe a gauche
    (not(bombes(Pos+TaillePlateau, Temps)), Temps < 4), % bombe en dessous
    (not(bombes(Pos-TaillePlateau, Temps)), Temps < 4), % bombe  dessus
    (not(bombes(Pos+2, Temps)); Temps >= 3; ((nth0(Pos+1, Plateau, Case), Case=1))), % bombe 2 case a droite sans mur entre
    (not(bombes(Pos-2, Temps)); Temps >= 3; ((nth0(Pos-1, Plateau, Case), Case=1))),
    (not(bombes(Pos+(2*TaillePlateau), Temps)); Temps < 3; ((nth0(Pos+TaillePlateau, Plateau, Case), Case==1))),
    (not(bombes(Pos-(2*TaillePlateau), Temps)); Temps < 3; ((nth0(Pos-TaillePlateau, Plateau, Case), Case==1))).

isPossible(NewPos, Board) :- not(bombes(NewPos,_)), not(joueursSav(NewPos,-1)), nth0(NewPos, Board, Case), Case==0.
isPossible(FormerPos,NewPos, Board) :- not(bombes(NewPos,_)), (not(joueursSav(NewPos,-1));FormerPos==NewPos), nth0(NewPos, Board, Case), Case==0.

posAdjacentes(Pos, TaillePlateau, [Haut, Gauche, Droite, Bas]) :- Haut is Pos-TaillePlateau, Gauche is Pos-1, Droite is Pos+1, Bas is Pos + TaillePlateau.

posAdjacentesPossibles(_,[],_).
posAdjacentesPossibles(Board, [X|L], PAP) :- posAdjacentesPossibles(Board, L, NewPAP), append(PAP,[X],NewPAP), isPossible(X, Board).
posAdjacentesPossibles(Board, [_|L], PAP) :- posAdjacentesPossibles(Board, L, PAP).

posAdjacentesSafe([],_,_,_). % condition de sortie : on a teste toutes les positions adjacentes possibles
posAdjacentesSafe([X|ListeIndex],Plateau,TaillePlateau, PosSafes) :- posAdjacentesSafe(ListeIndex,Plateau,TaillePlateau,NewPosSafes),isSafe(X,Plateau,TaillePlateau), append(PosSafes, [X], NewPosSafes). % la position adjacente est safe
posAdjacentesSafe([_|ListeIndex],Plateau, TaillePlateau, PosSafes) :- posAdjacentesSafe(ListeIndex,Plateau, TaillePlateau, PosSafes). % la position adjacente n'est pas safe



% iav1 : fait tout de maniere random
ia(Plateau, PosIndex, NewPosIndex, BombePosee, iav1) :- repeat, Move is random(7), indexAction(Move, I, BombePosee), NewPosIndex is PosIndex+I, isPossible(NewPosIndex, PosIndex, Plateau), !.

% iav2 : Detecte et evite les zones de danger des bombes et bouge de
% maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, NewPosIndex, TaillePlateau, BombePosee, iav2) :-
    repeat, (isSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isSafe(NewPosIndex, Board, TaillePlateau);
            Move is random(5),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif),
    nth0(NewPosIndex, Board, Elem), Elem==0, !.

% iav3 : detecte et evite les zones de danger
% et cherche si un deplacement peut la mettre en securite si pas safe
ia(Board, PosIndex, NewPosIndex, TaillePlateau,BombePosee, iav3) :-
    repeat, (isSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isSafe(NewPosIndex, Board, TaillePlateau), isPossible(NewPosIndex, PosIndex, Board),!; % Si en dehors de zone de danger : random
            posAdjacentes(PosIndex, TaillePlateau, PosAdjacentes), posAdjacentesPossibles(Board, PosAdjacentes, PosAdjacentesPossibles),
	    posAdjacentesSafe(PosAdjacentesPossibles, Board, TaillePlateau, PosAdjacentesSafes),
	     % si PosAdjacentesSafes est vide : piocher dans PosAdjacentesPossibles
	     ((length(PosAdjacentesPossibles,0)) ->
	     random_member(NewPosIndex, posAdjacentes);
	     random_member(NewPosIndex, PosAdjacentesSafes))),
    !.

% Non fonctionnelle !
% iav4 : se rapproche de l'adversaire pour poser des bombes avec les
% fonctionnalites precedentes
ia(Board, PosIndex, NewPosIndex, TaillePlateau,BombePosee, iav4) :-
    repeat, (isSafe(PosIndex, Board, TaillePlateau) ->
	    % si Safe :
            repeat, Move is random(7),indexAction(Move, MvmtRelatif,BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isSafe(NewPosIndex, Board, TaillePlateau), isPossible(NewPosIndex, PosIndex, Board),!;
	         % si loin de l'adversaire le + proche : random mais essaye de s'approcher
		 % si proche de l'adversaire : random mais a + de chances de poser des bombes
	    % Si dans zone de danger : on regarde quelles positions adjacentes sont safe
            posAdjacentes(PosIndex, TaillePlateau, PosAdjacentes), posAdjacentesPossibles(Board, PosAdjacentes, PosAdjacentesPossibles),
	    posAdjacentesSafe(PosAdjacentesPossibles, Board, TaillePlateau, PosAdjacentesSafes),
	     % si aucune position adjacente n'est safe, on en choisit une au hasard
	     ((length(PosAdjacentesPossibles,0)) ->
	     random_member(NewPosIndex, posAdjacentes);
	     random_member(NewPosIndex, PosAdjacentesSafes))),
    !.


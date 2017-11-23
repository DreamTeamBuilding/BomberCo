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


distance(Pos1, Pos2, Distance) :-  taillePlateau(Taille), Pos1X = (Pos1 mod Taille), Pos2X = (Pos2 mod Taille), Pos1Y = (div(Pos1,Taille)), Pos2Y = (div(Pos2,Taille)), DiffX is abs(Pos1X-Pos2X), DiffY is abs(Pos1Y-Pos2Y), Distance is (DiffX+DiffY).

adversairePlusProche(_, [], _).
adversairePlusProche(Pos, [PosJoueur|L], DistancePP) :- distance(Pos,PosJoueur,Distance), (Distance=<DistancePP) ,adversairePlusProche(Pos,L,Distance).
adversairePlusProche(Pos, [_|L],DistancePP) :- adversairePlusProche(Pos,L,DistancePP).

isSafe(Pos, Plateau) :-  % la case a l'index Pos est safe ?
	taillePlateau(TaillePlateau),
    (not(bombes(Pos, Temps)); Temps >= 5), % bombe sur le joueur
    (not(bombes(Pos+1, Temps)); Temps >= 4), % bombe a droite
    (not(bombes(Pos-1, Temps)); Temps >= 4), % bombe a gauche
    (not(bombes(Pos+TaillePlateau, Temps)); Temps >= 4), % bombe en dessous
    (not(bombes(Pos-TaillePlateau, Temps)); Temps >= 4), % bombe  dessus
    (not(bombes(Pos+2, Temps)); Temps >= 3; ((nth0(Pos+1, Plateau, Case), Case=1))), % bombe 2 case a droite sans mur entre
    (not(bombes(Pos-2, Temps)); Temps >= 3; ((nth0(Pos-1, Plateau, Case), Case=1))),
    (not(bombes(Pos+(2*TaillePlateau), Temps)); Temps < 3; ((nth0(Pos+TaillePlateau, Plateau, Case), Case==1))),
    (not(bombes(Pos-(2*TaillePlateau), Temps)); Temps < 3; ((nth0(Pos-TaillePlateau, Plateau, Case), Case==1))).

isPossible(FormerPos,NewPos, Board) :- not(bombes(NewPos,_)), (not(joueursSav(_,NewPos,-1));FormerPos==NewPos), nth0(NewPos, Board, 0).

% Liste des positions adjacentes a Pos
posAdjacentes(Pos, [Haut, Gauche, Droite, Bas]) :- taillePlateau(TaillePlateau), Haut is Pos-TaillePlateau, Gauche is Pos-1, Droite is Pos+1, Bas is Pos + TaillePlateau.

% Liste des positions accessibles depuis Pos
posSuivantes(Pos, PositionsSuivantes) :- append(posAdjacentes(Pos,_),Pos,PositionsSuivantes).

% Liste des positions realisables depuis FormerPos (pas d'obstacle)
posSuivantesPossibles(_,_,[],_).
posSuivantesPossibles(Board, FormerPos,[X|ListePos], PosSuivantesPossibles) :- posSuivantesPossibles(Board, FormerPos, ListePos, NewPAP), append(PosSuivantesPossibles,[X],NewPAP), isPossible(FormerPos, X, Board).
posSuivantesPossibles(Board, FormerPos, [_|L], PAP) :- posSuivantesPossibles(Board, FormerPos, L, PAP).

% Liste des positions safe
posSuivantesSafe([],_,_).
posSuivantesSafe([X|ListeIndex],Plateau, PosSafes) :- posSuivantesSafe(ListeIndex,Plateau,NewPosSafes),isSafe(X,Plateau), append(PosSafes, [X], NewPosSafes). % la position est safe
posSuivantesSafe([_|ListeIndex],Plateau, PosSafes) :- posSuivantesSafe(ListeIndex,Plateau, PosSafes). % la position n'est pas safe

% posAdjacentesPlusProches(Pos, PositionsAdjacentes, MeilleurMouvement).

% iav1 : fait tout de maniere random
ia(Plateau, PosIndex, NewPosIndex, BombePosee, iav1) :- %posSuivantes(PosIndex, PositionsSuivantes), posSuivantesPossibles(Plateau, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	  %(length(PosSuivantesPossibles,0) -> NewPosIndex is PosIndex, BombePosee is 0;
	 repeat, Move is random(7), indexAction(Move,I,BombePosee), NewPosIndex is PosIndex+I,isPossible(PosIndex, NewPosIndex, Plateau), !.

% iav2 : Detecte et evite les zones de danger des bombes et bouge de
% maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, NewPosIndex, BombePosee, iav2) :-
	posSuivantes(PosIndex, PositionsSuivantes), posSuivantesPossibles(Board, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	 (length(PosSuivantesPossibles,0) -> NewPosIndex is PosIndex, BombePosee is 0;
	 repeat, (isSafe(PosIndex, Board) ->
            repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isPossible(PosIndex,NewPosIndex,Board), isSafe(NewPosIndex, Board);
            Move is random(5),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isPossible(PosIndex,NewPosIndex, Board), !)).

% iav3 : detecte et evite les zones de danger
% et cherche si un deplacement peut la mettre en securite si pas safe
ia(Board, PosIndex, NewPosIndex,BombePosee, iav3) :-
    repeat, (isSafe(PosIndex, Board) ->
            repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isSafe(NewPosIndex, Board), isPossible(PosIndex, NewPosIndex, Board),!; % Si en dehors de zone de danger : random
            posAdjacentes(PosIndex, PosAdjacentes), posSuivantesPossibles(Board,PosIndex, PosAdjacentes, PosSuivantesPossibles),
	    posSuivantesSafe(PosSuivantesPossibles, Board, PosSuivantesSafes),
	     % si PosSuivantesSafes est vide : piocher dans PosSuivantesPossibles
	     ((length(PosSuivantesSafes,0)) ->
	     random_member(NewPosIndex, PosSuivantesPossibles);
	     random_member(NewPosIndex, PosSuivantesSafes))),
    !.


% iav4 : se rapproche de l'adversaire pour poser des bombes avec les
% fonctionnalites precedentes
ia(Board, PosIndex, NewPosIndex,BombePosee, iav4) :-
    repeat, (isSafe(PosIndex, Board) ->
	    % si Safe :
	    (joueursSav(_,PosJoueurs,-1), adversairePlusProche(PosIndex, PosJoueurs, DistanceVolOiseau), DistanceVolOiseau =< 3 ->
		% si proche de l'adversaire le + proche : random mais a plus de chances de bomber
	    repeat, Move is random(10*(4-DistanceVolOiseau)), (Move > 6 -> Move = 6; true), indexAction(Move,MvmtRelatif,BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isPossible(PosIndex, NewPosIndex,Board), isSafe(NewPosIndex,Board),!;
	    % si loin de l'adversaire le + proche : random mais essaye de s'approcher
	    posSuivantes(PosIndex, PosSuivantes),
	    posSuivantesPossibles(Board, PosIndex, PosSuivantes, PosSuivantesPossibles),
	    posSuivantesSafe(PosSuivantesPossibles, Board, PosSuivantesSafes),
	    posAdjacentesPlusProches(PosIndex, PosSuivantesSafes, MeilleurMouvement)),

	    % Si dans zone de danger : on regarde quelles positions adjacentes sont safe
            posAdjacentes(PosIndex, PosAdjacentes), posSuivantesPossibles(Board, PosIndex, PosAdjacentes, PosAdjacentesPossibles),
	    posSuivantesSafe(PosAdjacentesPossibles, Board, PosAdjacentesSafes),
	     % si aucune position adjacente n'est safe, on en choisit une au hasard
	     ((length(PosAdjacentesPossibles,0)) ->
	     random_member(NewPosIndex, PosAdjacentes);
	     random_member(NewPosIndex, PosAdjacentesSafes))),
    !.

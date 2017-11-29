%%%%% Positionne les joueurs dans les coins du plateau
initJoueurs:-
	taillePlateau(TaillePlateau),
	nbJoueurs(NbJoueurs),
	(joueursSav(_,_,_) -> retractall(joueursSav(_,_,_)); true),
	(NbJoueurs < 5,NbJoueurs >1),

	Position is TaillePlateau +1, assert(joueursSav(0,Position,-1)),
	Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2, assert(joueursSav(1,Position2,-1)),
	(NbJoueurs < 3 -> true ; (Position3 is TaillePlateau*2-2), assert(joueursSav(2,Position3,-1))),
	(NbJoueurs < 4 -> true ; (Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1, assert(joueursSav(3,Position4,-1)))).

actualiserJoueur(IdJoueur,NewPosJoueur):-
	retract(joueursSav(IdJoueur,_,StatusPrec)),assert(joueursSav(IdJoueur,NewPosJoueur,StatusPrec)).

joueurSuivant(IdJoueur,IdJoueurSuivant):-
	nbJoueurs(NbJoueurs),
	Id is IdJoueur + 1,
	IdJoueurSuivant is mod(Id,NbJoueurs).

plusieursEnVie:-joueursSav(X,_,-1),joueursSav(Y,_,-1),Y\==X.

tuer(IdJoueur):-
	retract(joueursSav(IdJoueur, Position, _)),
	assert(joueursSav(IdJoueur, Position, 0)).

jouerLeJoueur(Action, Plateau, PosIndex, NewPosIndex, BombePosee):-
	posSuivantes(PosIndex, PositionsSuivantes),
	posSuivantesPossibles(Plateau, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	% TODO : supprimer?
	(length(PosSuivantesPossibles,0) ->
	 (NewPosIndex is PosIndex, BombePosee is 0)
	;
	 (indexAction(Move,I,BombePosee), NewPosIndex is PosIndex+I,(not(isPossible(PosIndex, NewPosIndex, Plateau)) -> NewPosIndex is PosIndex ; true))
	).

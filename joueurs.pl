%%%%% Positionne les joueurs dans les coins du plateau
initJoueurs(NbJoueurs, TaillePlateau):-
	(not(nbJoueurs(_));retractall(nbJoueurs(_))),
	assert(nbJoueurs(NbJoueurs)),
	nbJoueurs(NbJoueurs),
	(not(joueursSav(_,_,_)) ; retractall(joueursSav(_,_,_))),
	(NbJoueurs < 5,NbJoueurs >1),

	Position is TaillePlateau +1, assert(joueursSav(0,Position,-1)),
	Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2, assert(joueursSav(1,Position2,-1)),
	(NbJoueurs < 3 ; (Position3 is TaillePlateau*2-2), assert(joueursSav(2,Position3,-1))),
	(NbJoueurs < 4 ; (Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1, assert(joueursSav(3,Position4,-1)))).

actualiserJoueur(IdJoueur,NewPosJoueur):-
	retract(joueursSav(IdJoueur,_,StatusPrec)),assert(joueursSav(IdJoueur,NewPosJoueur,StatusPrec)).

joueurSuivant(IdJoueur,IdJoueurSuivant):-
	nbJoueurs(NbJoueurs),
	Id is IdJoueur + 1,
	IdJoueurSuivant is mod(Id,NbJoueurs).

plusieursEnVie:-joueursSav(X,_,-1),joueursSav(Y,_,-1),Y\==X.

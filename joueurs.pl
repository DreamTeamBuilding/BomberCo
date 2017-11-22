%%%%% Positionne les joueurs dans les coins du plateau
initJoueurs(NbJoueurs, TaillePlateau):-
	(not(nbJoueurs(_));retractall(nbJoueurs(_))),
	assert(nbJoueurs(NbJoueurs)),
	nbJoueurs(NbJoueurs),
	(not(joueursSav(_,_)) ; retractall(joueursSav(_,_))),
	(NbJoueurs < 5,NbJoueurs >1),

	Position is TaillePlateau +1, assert(joueursSav(Position,-1)), 
	Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2, assert(joueursSav(Position2,-1)), 
	(NbJoueurs < 3 ; (Position3 is TaillePlateau*2-2), assert(joueursSav(Position3,-1))),
	(NbJoueurs < 4 ; (Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1, assert(joueursSav(Position4,-1)))).

	
plusieursEnVie:-joueursSav(X,-1),joueursSav(Y,-1),Y\==X.
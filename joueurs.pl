%%%%% Positionne les joueurs dans les coins du plateau
initJoueurs(NbJoueurs, TaillePlateau):-

	nbJoueurs(NbJoueurs),
	(not(joueursSav(_,_)) ; retractall(joueursSav(_,_))),
	
	length(Joueurs,NbJoueurs),
    length(EtatsJoueurs,NbJoueurs),
	(NbJoueurs < 5,NbJoueurs >1),
	nth0(0, Joueurs, Position), Position is TaillePlateau +1,
	nth0(1, Joueurs, Position2), Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2,
	(NbJoueurs < 3 ; (nth0(2, Joueurs, Position3), Position3 is TaillePlateau*2-2)),
	(NbJoueurs < 4 ; (nth0(3, Joueurs, Position4), Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1)),
    assert(joueursSav(Joueurs,EtatsJoueurs)),
	assert(nbJoueurs(NbJoueurs)).
	
	
compteSurvivants(0,[]).
compteSurvivants(NbVivants,[X|Joueurs]):- compteSurvivants(NbVivantsPrec,Joueurs),
	(var(X) -> NbVivants is NbVivantsPrec +1; NbVivants is NbVivantsPrec).
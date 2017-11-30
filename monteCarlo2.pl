iaMC(PosIndex, NewPosIndex, BombePosee, iaMC) :-
	posSuivantes(PosIndex, PositionsSuivantes),
	posSuivantesPossibles(PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	writeln(PosSuivantesPossibles),
	joueursSav(IdJoueur,PosIndex,_),
	tourActuel(TA),
	testerMeilleurCoup(PosSuivantesPossibles, PosIndex, NewPosIndex, BombePosee, _ScoreDeLAction, IdJoueur, TA)
	/*
	Utiliser Coup (indexAction) au lieu de NewPosIndex, pour condenser la position et la bombe
	*/
	.
% Je vois pas pourquoi on a besoin de PosActuelle :/
% Lance l'initialisation de la recherche de max
testerMeilleurCoup([PremierePos|AutresPos], PosActuelle, MeilleurePos, BombePosee, MeilleurScore,IdJoueur, TA) :-
	testerMeilleurCoup(AutresPos, PosActuelle, PremierePos, MeilleurePos,BombePosee,BombePosee, -10000000, MeilleurScore,IdJoueur, TA). %% l'init du meilleur score est degueu ^^

% Validation du max
testerMeilleurCoup([], _, MeilleurePos, MeilleurePos,BombePosee,BombePosee, MeilleurScore, MeilleurScore,_,_).
% Recherche du max parmis les autres coups
testerMeilleurCoup([X|L], PosActuelle, MeilleurePos0, MeilleurePos,BombePosee0, BombePosee, MeilleurScore0, MeilleurScore,IdJoueur,TA) :-

	%sav des dynamics (plateauSav, joueursSav, bombes, joueurActuel, tourActuel)

	simulationMC(X, Bombe, ScoreTrouve,_NbIterationActuelle,IdJoueur,TA),
	%restaurer les dynamics.



	% tests pour le maximum
	(   ScoreTrouve > MeilleurScore0 ->
	MeilleurScore1 is ScoreTrouve, MeilleurePos1 is X, BombePosee1 is Bombe;
	MeilleurScore1 is MeilleurScore0, MeilleurePos1 is MeilleurePos0, BombePosee1 is BombePosee0),
	testerMeilleurCoup([X|L], PosActuelle, MeilleurePos1, MeilleurePos, BombePosee1,BombePosee, MeilleurScore1, MeilleurScore,IdJoueur).

jouerMC(IdGagnant):- ((gameover, joueursSav(IdGagnant,_,-1)) ; tourActuel(50)), !. % Mettre
jouerMC(IdGagnant) :-
	joueurActuel(IdJoueur),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			(IdJoueur==0 ->
				iaJ1(Ia) ; iaGenerale(Ia)
			),
			ia(PosJoueur, NewPosJoueur, BombePosee, iav1),
			% Debug
			% afficherLesDetails(IdJoueur, NewPosJoueur, BombePosee),
			actualiserJoueur(IdJoueur,NewPosJoueur),
			(BombePosee==1 -> ajouterBombe(NewPosJoueur); true)

		)
	),
	decrementerBombes,
	exploserBombes,
	% Tuer des gens,

	joueurSuivant(IdJoueur,IdJoueurSuivant),

	retract(joueurActuel(_)),
	assert(joueurActuel(IdJoueurSuivant)),

	tourActuel(TA),
	retract(tourActuel(_)),
	TourSuivant is TA + 1,
	assert(tourActuel(TourSuivant)),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	jouerMC(IdGagnant),
	!
	.

simulationMC(NewPosIndex, BombePosee, Score, 250,_,_) :- !.
simulationMC(PosIndex, BombePosee, Score, NbIterationActuelle,IdJoueurMC,TourDebutSimulation) :-
	% deplacer le joueur sur la nouvelle Pos avant le debut de la partie simulee et creer une bombe si necessaire
	joueursSav(IdJoueurMC,PosIndex,_),
	(   BombePosee == 1 -> ajouterBombe(PosIndex);true),
	%Pour moi le reset des dynamiques est ici : a chaque fois qu'on a une partie finie, on reset le jeu et on recommence tout en modifiant le score et tout

	jouerMC(IdGagnant),
	% si Score n'est pas instancie, on l'initialise a 0
	(   var(Score) -> Score is 0;true),
	tourActuel(TA),
	% En cas d'egalite
	(   TA < 50 -> true ;
	(   IdGagnant == IdJoueurMC ->
	Score is Score+(10000/(TA*TA));% EQUILIBRAGE : tests a la main pour cette expression qui me parait pas horrible
	Score is Score-(7000/(TA*TA))), % EQUILIBRAGE : une défaite est moins importante qu'une victoire car une défaite peut etre évitée le moment venu et une victoire provoquée
	NbIterationActuelle is NbIterationActuelle+1, % instanciee ?
	simulationMC(PosIndex, BombePosee, Score, NbIterationActuelle,IdJoueurMC))
	.

iaMC(PosIndex, NewPosIndex, BombePosee, iaMC) :-
	posSuivantes(PosIndex, PositionsSuivantes),
	posSuivantesPossibles(PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	writeln(PosSuivantesPossibles),
	joueursSav(IdJoueur,PosIndex,_),
	testerMeilleurCoup(PosSuivantesPossibles, PosIndex, NewPosIndex, BombePosee, _ScoreDeLAction, IdJoueur)
	/*
	Utiliser Coup (indexAction) au lieu de NewPosIndex, pour condenser la position et la bombe
	*/
	.
% Je vois pas pourquoi on a besoin de PosActuelle :/
% Lance l'initialisation de la recherche de max
testerMeilleurCoup([PremierePos|AutresPos], PosActuelle, MeilleurePos, BombePosee, MeilleurScore,IdJoueur) :-
	testerMeilleurCoup(AutresPos, PosActuelle, PremierePos, MeilleurePos,BombePosee,BombePosee, -10000000, MeilleurScore,IdJoueur). %% l'init du meilleur score est degueu ^^

% Validation du max
testerMeilleurCoup([], _, MeilleurePos, MeilleurePos,BombePosee,BombePosee, MeilleurScore, MeilleurScore,_).
% Recherche du max parmis les autres coups
testerMeilleurCoup([X|L], PosActuelle, MeilleurePos0, MeilleurePos,BombePosee0, BombePosee, MeilleurScore0, MeilleurScore,IdJoueur) :-

	%sav des dynamics (plateauSav, joueursSav, bombes, joueurActuel, tourActuel)

	simulationMC(X, Bombe, ScoreTrouve,_NbIterationActuelle,IdJoueur),
	%restaurer les dynamics.



	% tests pour le maximum
	(   ScoreTrouve > MeilleurScore0 ->
	MeilleurScore1 is ScoreTrouve, MeilleurePos1 is X, BombePosee1 is Bombe;
	MeilleurScore1 is MeilleurScore0, MeilleurePos1 is MeilleurePos0, BombePosee1 is BombePosee0),
	testerMeilleurCoup([X|L], PosActuelle, MeilleurePos1, MeilleurePos, BombePosee1,BombePosee, MeilleurScore1, MeilleurScore,IdJoueur).

jouerMC(IdGagnant):- ((gameover, joueursSav(IdGagnant,_,-1)) ; tourActuel(50)), !. % Nb de tours suffisant ? devrait etre scale en fonction du nombre de joueurs
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

simulationMC(NewPosIndex, BombePosee, Score, 250,_) :- !.
simulationMC(PosIndex, BombePosee, Score, NbIterationActuelle,IdJoueurMC) :-
	% deplacer le joueur sur la nouvelle Pos avant le debut de la partie simulee et creer une bombe si necessaire
	%Pour moi le reset des dynamiques est ici : a chaque fois qu'on a une partie finie, on reset le jeu et on recommence tout en modifiant le score et tout
	jouerMC(IdGagnant),
	% si Score n'est pas instancie, on l'initialise a 0
	(   var(Score) -> Score is 0;true),
	tourActuel(TA),
	% En cas d'egalite
	(   TA < 50 -> true ;  % Que faire en cas d'egalite ?
	(   IdGagnant == IdJoueurMC ->
	Score is Score+(10000/(TA*TA));% EQUILIBRAGE : tests a la main pour cette expression qui me parait pas horrible
	Score is Score-(7000/(TA*TA))), % EQUILIBRAGE : une défaite est moins importante qu'une victoire car une défaite peut etre évitée le moment venu et une victoire provoquée
	NbIterationActuelle is NbIterationActuelle+1, % instanciee ?
	simulationMC(PosIndex, BombePosee, Score, NbIterationActuelle,IdJoueurMC))
	.

/*
jouerSimulationsPosition(_,_,CompteurVictoires, VictoiresTotales, 0) :-
	VictoiresTotales is CompteurVictoires.
jouerSimulationsPosition(IdJoueur, CompteurVictoires, VictoiresTotales, NewPosJoueur, NbSimulations) :-
		write("hello simu"),
	plateauSav(PlateauTEMP),
	assert(plateauSavMC(PlateauTEMP)),
	joueursSav(IdTEMP,_,_),
	joueursSav(IdTEMP,PositionsTEMP,EtatsTEMP),!,
	assert(joueursSavMC(IdTEMP,PositionsTEMP,EtatsTEMP)),
		write("2"),
	%bombes(PosTEMP,_),
	%bombes(PosTEMP,TempsTEMP),!,
	%assert(bombesMC(PosTEMP,TempsTEMP)),
		write("3"),
	indexAction(CodeTEMP,_,_),
	indexAction(CodeTEMP,DeplacementTEMP,PoserTEMP),!,
	assert(indexAction(CodeTEMP,DeplacementTEMP,PoserTEMP)),
	taillePlateau(TailleTEMP),
	assert(taillePlateau(TailleTEMP)),
	nbJoueurs(NbTEMP),
	assert(nbJoueurs(NbTEMP)),
	joueurActuel(JoueurTEMP),
	assert(joueurActuel(JoueurTEMP)),
	tourActuel(TourTEMP),
	assert(tourActuel(TourTEMP)),
	fin(FinTEMP),
	assert(fin(FinTEMP)),

	actualiserJoueur(IdJoueur,NewPosJoueur),!,
	write("hello simu 3"),

	jouer(IdGagnant),
	write("hello simu 4"),

	%(IdGagnant is IdJoueur -> CompteurVictoires is CompteurVictoires + 1; true),
	NbSimulations is NbSimulations-1,

	write("hello simu 5"),

	jouerSimulationsPosition(IdJoueur, CompteurVictoires, VictoiresTotales, NewPosJoueur, NbSimulations),
	write("hello simu 6")

	.

jouerSimulationsBombe(_, CompteurVictoires, VictoiresTotales, _, 0) :- VictoiresTotales is CompteurVictoires.
jouerSimulationsBombe(IdJoueur, CompteurVictoires, VictoiresTotales, PosJoueur, NbSimulations) :-
	plateauSavMC = plateauSav,
	joueursSavMC = joueursSav,
	bombesMC = bombes,
	indexActionMC = indexAction,
	taillePlateauMC = taillePlateau,
	nbJoueursMC = nbJoueurs,
	joueurActuelMC = joueurActuel,
	tourActuelMC = tourActuel,
	finMC = fin,
	ajouterBombeMC(PosJoueur),
	jouerMC(IdGagnant),
	(IdGagnant is IdJoueur -> CompteurVictoires is CompteurVictoires + 1; true),
	NbSimulations is NbSimulations -1,
	jouerSimulationsBombe(IdJoueur, CompteurVictoires, VictoiresTotales, PosJoueur, NbSimulations).




*/

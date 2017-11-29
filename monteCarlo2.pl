iaMC(PosIndex, NewPosIndex, BombePosee, iaMC) :-
	posSuivantes(PosIndex, PositionsSuivantes),
	posSuivantesPossibles(PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	writeln(PosSuivantesPossibles),
	testerMeilleurCoup(PosSuivantesPossibles, PosIndex, NewPosIndex, _ScoreDeLAction)
	/*
	Utiliser Coup (indexAction) au lieu de NewPosIndex, pour condenser la position et la bombe
	*/
	.

% Lance l'initialisation de la recherche de max
testerMeilleurCoup([PremierePos|AutresPos], PosActuelle, MeilleurePos, MeilleurScore) :-
	testerMeilleurCoup(AutresPos, PosActuelle, PremierePos,MeilleurPos, -10000000, MeilleurScore).

% Validation du max
testerMeilleurCoup([], _, MeilleurePos, MeilleurePos, MeilleurScore, MeilleurScore)
% Recherche du max parmis les autres coups
testerMeilleurCoup([X|L], PosActuelle, MeulleurePos0, MeilleurePos, MeilleurScore0, MeilleurScore) :-
	/*
	sav des dynamics (plateauSav, joueursSav, bombes, joueurActuel, tourActuel)
	
	jouer le coup
	faire plein (a definir) de parties a partir de la en se remplacer par un iav1 (dans la methode jouerMC !!)
	regarder le tourActuel, et IdGagnant pour attribuer un score à ce coup
	enregistrer le coup comme meilleur si c'est le cas
	
	restaurer les dynamics.
	
	*/
	% tests pour le maximum
	/*
		if(scoreTrouve > MeilleurScore0){
			MeilleurScore1 = scoreTrouve,
			MeilleurePos1 = posTrouvee
		}else{
			MeilleurScore1 = MeilleurScore0,
			MeilleurePos1 = MeilleurePos0
		}
	*/
	testerMeilleurCoup([X|L], PosActuelle, MeulleurePos1, MeilleurePos, MeilleurScore1, MeilleurScore).

jouerMC(IdGagnant):- (gameover, joueursSav(IdGagnant,_,-1) ; tourActuel(50)), !.
jouerMC(IdGagnant) :-
	joueurActuel(IdJoueur),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	taillePlateau(TaillePlateau),
/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	displayBoard(TaillePlateau),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		( 
			(IdJoueur==0 ->
				iaJ1(Ia) ; iaGenerale(Ia)
			),
			ia(PosJoueur, NewPosJoueur, BombePosee, Ia),
			%iaMC(PosJoueur, NewPosJoueur, BombePosee, iaMC),
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
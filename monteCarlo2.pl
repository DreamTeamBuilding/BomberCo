iaMC(PosIndex, NewPosIndex, BombePosee, iaMC) :-
	joueursSav(IdJoueur,PosIndex,_),
	tourActuel(TA),
	Actions = [1,2,3,4,5,6],
	testerMeilleurCoup(Actions, ActionJouee, _ScoreDeLAction, IdJoueur, TA)
	.

% Lance l'initialisation de la recherche de max
testerMeilleurCoup([PremiereAction|AutresActions], MeilleureAction, MeilleurScore,IdJoueur,TA) :-
	testerMeilleurCoup([PremiereAction|AutresActions], PremiereAction, MeilleureAction, -10000000, MeilleurScore,IdJoueur,TA). %% l'init du meilleur score est degueu ^^

% Validation du max
testerMeilleurCoup([], MeilleureAction, MeilleureAction, MeilleurScore, MeilleurScore,_,_).
% Recherche du max parmis les autres coups
testerMeilleurCoup([X|L], MeilleureAction0, MeilleureAction, MeilleurScore0, MeilleurScore,IdJoueur,TA) :-

	% test du is possible

	simulationMC(X, 0,ScoreFinal,0,IdJoueur,TA),
	%restaurer les dynamics.

	% tests pour le maximum
	(   ScoreTrouve > MeilleurScore0 ->
	MeilleurScore1 is ScoreTrouve, MeilleureAction1 is X;
	MeilleurScore1 is MeilleurScore0, MeilleureAction1 is MeilleureAction0),
	testerMeilleurCoup([X|L], MeilleureAction1, MeilleureAction, MeilleurScore1, MeilleurScore,IdJoueur,TA).

simulationMC(Action, ScoreFinal,ScoreFinal, 250,_,_) :- !.
simulationMC(Action, Score,ScoreFinal, NbIterationActuelle,IdJoueurMC,TourDebutSimulation) :-
%sauver etat

%jouer mov 1
	/*
	% deplacer le joueur sur la nouvelle Pos avant le debut de la partie simulee et creer une bombe si necessaire
	joueursSav(IdJoueurMC,PosIndex,_),
	(   BombePosee == 1 -> ajouterBombe(PosIndex);true),
	%Pour moi le reset des dynamiques est ici : a chaque fois qu'on a une partie finie, on reset le jeu et on recommence tout en modifiant le score et tout
	*/
%jouer jusqu'a finie
	assert(tourActuel(TourDebutSimulation)),
	jouerMC(IdGagnant),
%calcul du score
	% si Score n'est pas instancie, on l'initialise a 0
	(   var(Score) -> ScoreSuiv is 0;true),
	tourActuel(TA),
	% En cas d'egalite
	(   TA < 50 -> true ;
	(   IdGagnant == IdJoueurMC ->
	ScoreSuiv is Score+(10000/(TA*TA));% EQUILIBRAGE : tests a la main pour cette expression qui me parait pas horrible
	ScoreSuiv is Score-(7000/(TA*TA))), % EQUILIBRAGE : une défaite est moins importante qu'une victoire car une défaite peut etre évitée le moment venu et une victoire provoquée
	NbIterationSuiv is NbIterationActuelle+1, % instanciee ?
%restaurer etat

%lancer simu suivante
	simulationMC(Action, ScoreSuiv,ScoreFinal, NbIterationSuiv,IdJoueurMC,TourDebutSimulation))


	.

jouerMC(IdGagnant):- ((gameover, joueursSav(IdGagnant,_,-1)) ; tourActuel(50)), !. % Mettre
jouerMC(IdGagnant) :-
	joueurActuel(IdJoueur),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			(IdJoueur==0 ->
				iaJ1(Ia) ; iaGenerale(Ia)
			),
			ia(PosJoueur, NewPosJoueur, BombePosee, Ia),
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

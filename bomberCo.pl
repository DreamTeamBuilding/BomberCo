:- dynamic
	plateauSav/1,
	joueursSav/3,%joueursSav(Id, Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/3,%indexAction(CodeMouvement, Deplacement, PoserBombe)
	porteeBombes/1, %portee des bombes
	taillePlateau/1,
	nbJoueurs/1,
	joueurActuel/1,
	tourActuel/1, %A supprimer
	fin/1,
	iaJ1/1, % Ia du joueur 1
	iaGenerale/1. % Ia du reste des joueurs
:-[ia].
:-[plateau].
:-[joueurs].
:-[bombes].
:-[ihm].
:-[tests].
:-[monteCarlo2].

% Condition d'arret : 10 iterations

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	jouer:- (gameover;tourActuel(50)), !, retract(fin(0)),assert(fin(1)).
/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
%jouer:- (gameover ; tourActuel(50)), !, taillePlateau(TaillePlateau), displayBoard(TaillePlateau), writeln('Game is Over.'),retract(fin(0)),assert(fin(1)).
jouer :-
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
	jouer,
	!
	.


jouerVraiJoueur(Action) :-
	joueurActuel(IdJoueur),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	taillePlateau(TaillePlateau),
/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	displayBoard(TaillePlateau),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			jouerLeJoueur(Action, PosJoueur, NewPosJoueur, BombePosee),
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
	jouer,
	!
	.

%%%%% Start !
init :-
/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
%	server(8000),
	true %a delete (me permet de commenter plus simplement la ligne au dessus)
	.

initGame(NbJoueurs, TaillePlateau) :-
	(fin(_) -> retractall(fin(_)); true),
	assert(fin(0)),

	(joueurActuel(_) -> retractall(joueurActuel(_)); true),
	assert(joueurActuel(0)),

	(tourActuel(_) -> retractall(tourActuel(_)); true),
	assert(tourActuel(0)),

    % Initialisation du plateau
	initPlateau(TaillePlateau),
	% Initialisation Player
	initJoueurs(NbJoueurs),
	% Initialisation des bombes
	initBombes,
	% Initialisation des regles de deplacement
	initIndex.

lancerPartie(NbJoueurs, TaillePlateau, Ia1, Ia2):-
	preparerIa(Ia1, Ia2),
	initGame(NbJoueurs, TaillePlateau).
	%jouer.

preparerIa(Ia1, Ia2) :-
	(iaJ1(_) -> retractall(iaJ1(_)); true),
	(iaGenerale(_) -> retractall(iaGenerale(_)); true),
	(Ia1==1 -> assert(iaJ1(iav1)) ; true),
	(Ia1==2 -> assert(iaJ1(iav2)) ; true),
	(Ia1==3 -> assert(iaJ1(iav3)) ; true),
	(Ia1==4 -> assert(iaJ1(iav3b)) ; true),
	(Ia1==5 -> assert(iaJ1(iav4)) ; true),
	(Ia2==1 -> assert(iaGenerale(iav1)) ; true),
	(Ia2==2 -> assert(iaGenerale(iav2)) ; true),
	(Ia2==3 -> assert(iaGenerale(iav3)) ; true),
	(Ia2==4 -> assert(iaGenerale(iav3b)) ; true),
	(Ia2==5 -> assert(iaGenerale(iav4)) ; true),
	(Ia1==0 -> assert(iaJ1(0)) ; true).

stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

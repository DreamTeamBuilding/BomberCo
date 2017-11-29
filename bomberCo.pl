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
	fin/1.
:-[ia].
:-[plateau].
:-[joueurs].
:-[bombes].
:-[ihm].
:-[tests].
:-[monteCarlo].

% Condition d'arret : 10 itérations

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
%jouer:- (gameover;tourActuel(50)), !, retract(fin(0)),assert(fin(1)).
/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
jouer:- (gameover;tourActuel(50)), !, taillePlateau(TaillePlateau), displayBoard(TaillePlateau), writeln('Game is Over.'),retract(fin(0)),assert(fin(1)).
jouer :-
	joueurActuel(IdJoueur),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	taillePlateau(TaillePlateau),
/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	displayBoard(TaillePlateau),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			plateauSav(Plateau),
			ia(Plateau, PosJoueur, NewPosJoueur, BombePosee, iav1),
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
	true %a delete (me permet de commenter plus simplement la ligne au dessus)
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

lancerPartie(NbJoueurs, TaillePlateau):-
	initGame(NbJoueurs, TaillePlateau),
	jouer.


stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

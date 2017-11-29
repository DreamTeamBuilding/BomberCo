:- dynamic
	plateauSav/1,
	joueursSav/3,%joueursSav(Id, Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/3,%indexAction(CodeMouvement, Deplacement, PoserBombe)
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
%jouer:- (gameover;tourActuel(500)), !, retract(fin(0)),assert(fin(1)).
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
			iaMC(Plateau, PosJoueur, NewPosJoueur, BombePosee, iaMC),
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
init(NbJoueurs, TaillePlateau) :-

	(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
	assert(nbJoueurs(NbJoueurs)),

	(taillePlateau(_) -> retractall(taillePlateau(_)); true),
	assert(taillePlateau(TaillePlateau)),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	%server(8000),
    lancerPartie
	.

initGame :-
	(fin(_) -> retractall(fin(_)); true),
	assert(fin(0)),

	(joueurActuel(_) -> retractall(joueurActuel(_)); true),
	assert(joueurActuel(0)),

	(tourActuel(_) -> retractall(tourActuel(_)); true),
	assert(tourActuel(0)),
    % Initialisation du plateau
	initPlateau,
	% Initialisation Player
	initJoueurs,
	% Initialisation des bombes
	initBombes,
	% Initialisation des regles de deplacement
	initIndex.

lancerPartie:-
	initGame,
	jouer.


stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

% Clean de dynamic
clean_dynamic:-
	retractall(plateauSav(_)),
	retractall(joueursSav(_,_,_)),
	retractall(bombes(_,_)),
	retractall(indexAction(_,_,_)),
	retractall(taillePlateau(_)),
	retractall(nbJoueurs(_)),
	retractall(joueurActuel(_)),
	retractall(tourActuel(_)),
	retractall(fin(_)).

/*
afficherLesDetails(Id, NP ,BombePosee):-
	% On récupère toutes les positions des joueurs
	findall(Positions,joueursSav(_,Positions,_),ListePositions),
	% On récupère toutes les positions des bombes
	findall(PositionsB,bombes(PositionsB, _),ListePositionsB),
	% On récupère les temps avant explosion
	findall(Tps,bombes(_,Tps),ListeTempsB),
	% On récupère les infos sur le joueurs actif
	joueursSav(Id, Pos, Stat),
	write('Liste des joueurs : '),writeln(ListePositions),
	write('Liste des bombes : '),writeln(ListePositionsB),
	write('Liste des temps : '),writeln(ListeTempsB),
	write('Tour du joueur : '), writeln(Id),
	write('Position : '), writeln(Pos),
	write('Status : '), writeln(Stat),
	write('Position suivante : '), writeln(NP),
	write('A pose une bombe? : '), writeln(BombePosee).
*/

:- dynamic
	plateauSav/1,
	joueursSav/3,%joueursSav(Id, Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/3,
	taillePlateau/1,
	nbJoueurs/1,
	fin/1.
:-[ia].
:-[plateau].
:-[joueurs].
:-[bombes].
:-[ihm].
:-[tests].

% Condition d'arrêt : 10 itérations
%jouer(_):- gameover, !, write('Game is Over.').
jouer:- nb_getval(tourActuel, TourActuel),TourActuel==1000, !,/* write('Game is Over.'),*/retract(fin(0)),assert(fin(1)).
jouer :-
	nb_getval(joueurActuel, JoueurActuel),
	nb_getval(tourActuel, TourActuel),
	
	TourSuiant is TourActuel + 1,
	taillePlateau(TaillePlateau),
	%displayBoard(TaillePlateau),
	joueursSav(JoueurActuel,PosJoueur,StatusJoueur),
	(
		not(joueursSav(JoueurActuel,_,-1))
	;
		plateauSav(Plateau),
		ia(Plateau, PosJoueur, NewPosJoueur, _BombePosee, iav1),
		actualiserJoueur(JoueurActuel,NewPosJoueur)%,
		%(BombePosee==1 -> ajouterBombe(NewPosJoueur))
		% TODO : pourquoi les joueurs se téléportent?
		% ia next move
		% jouer next move (deplacer, poser, rien)
	),
	
	joueurSuivant(JoueurActuel,IdJoueurSuivant),
	b_setval(joueurActuel, IdJoueurSuivant),
	b_setval(tourActuel, TourSuivant),
	%decrementerBombes
	% Decrementer bombes,
	% Tuer des gens,
	% Actualiser NextPlayer
	% Play next player

	% Delay pour les fps, wow, such graphismsz
	.

%%%%% Start !
init(NbJoueurs, TaillePlateau) :-
	assert(fin(0)),
    % Initialisation du plateau
	initPlateau(TaillePlateau),
    % Initialisation Player
    initJoueurs(NbJoueurs, TaillePlateau),
	% Initialisation des bombes
	initBombes,
	% Initialisation des regles de deplacement
	initIndex(TaillePlateau),
	server(8000),!
	/*;write('erreur')*/.
lancerPartie:-
	(not(fin(_));retractall(fin(_))),
	assert(fin(0)),
	nb_setval(joueurActuel,0),
	nb_setval(tourActuel,0),
	jouer/*;write('erreur')*/.
	
stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

moveJ1:-retract(joueursSav(0,Y,X)),YNext is Y+1,assert(joueursSav(0,YNext,X)).

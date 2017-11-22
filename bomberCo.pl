:- dynamic
	plateauSav/1,
	joueursSav/3,%joueursSav(Id, Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/3,
	taillePlateau/1,
	nbJoueurs/1.
:-[ia].
:-[plateau].
:-[joueurs].
:-[ihm].
:-[tests].

% Condition d'arrêt : 10 itérations
%jouer(_):- gameover, !, write('Game is Over.').
jouer(_,I):- I==50, !, write('Game is Over.').
jouer(IdJoueur,I) :-
	J is I+1,
	taillePlateau(TaillePlateau),
	displayBoard(TaillePlateau),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(
		not(joueursSav(IdJoueur,_,-1))
	;
		plateauSav(Plateau),
		ia(Plateau, PosJoueur, NewPosJoueur, BombePosee, iav1),
		actualiserJoueur(IdJoueur,NewPosJoueur),
		joueurSuivant(IdJoueur,IdJoueurSuivant),
		jouer(IdJoueurSuivant,J)
		% ia next move
		% jouer next move (deplacer, poser, rien)
	)
	% Decrementer bombes,
	% Tuer des gens,
	% Actualiser NextPlayer
	% Play next player

	% Delay pour les fps, wow, such graphismsz
	.

%%%%% Start !
init(NbJoueurs, TaillePlateau) :-
    % Initialisation du plateau
	initPlateau(TaillePlateau),
    % Initialisation Player
  initJoueurs(NbJoueurs, TaillePlateau),
	% Initialisation des relges de deplacement
	initIndex(TaillePlateau),
	server(8000),
	jouer(0,0);write('erreur').

stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

moveJ1:-retract(joueursSav(0,Y,X)),YNext is Y+1,assert(joueursSav(0,YNext,X)).
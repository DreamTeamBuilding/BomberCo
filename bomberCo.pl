:- dynamic
	plateauSav/1,
%TODO mettre un ID au joueur
	joueursSav/3,%joueursSav(Id, Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/3,
	taillePlateau/1,
	nbJoueurs/1.
:-[ia].
:-[plateau].
:-[joueurs].
:-[bombes].
:-[ihm].

% Condition d'arrêt : 10 itérations
%jouer(_):- gameover, !, write('Game is Over.').
jouer(_,I):- I==10, !, write('Game is Over.').
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
		(BombePosee==1 -> ajouterBombe(NewPosJoueur)),
		% TODO : pourquoi les joueurs se téléportent?
		joueurSuivant(IdJoueur,IdJoueurSuivant),
		jouer(IdJoueurSuivant,J)
		% ia next move
		% jouer next move (deplacer, poser, rien)
	)
	decrementerBombes
	% Decrementer bombes,
	% Tuer des gens,
	% Actualiser NextPlayer
	% Play next player

	% Delay pour les fps, wow, such graphismsz
	.

%%%%% Start !
init(NbJoueurs, TaillePlateau) :-
	(not(taillePlateau(_));retractall(taillePlateau(_))),
	(not(nbJoueurs(_));retractall(nbJoueurs(_))),
	assert(taillePlateau(TaillePlateau)),assert(nbJoueurs(NbJoueurs)) ,
  % Initialisation du plateau
	initPlateau(TaillePlateau),
  % Initialisation Player
  initJoueurs(NbJoueurs, TaillePlateau),
	% Initialisation des bombes
	initBombes,
	% Initialisation des regles de deplacement
	initIndex(TaillePlateau),
	% server(8000),
	jouer(0,0).

stop:-
	stopServer(8000).


%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

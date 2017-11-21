:- dynamic
	plateauSav/1,
%TODO mettre un ID au joueur
	joueursSav/2,%joueurs(Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/3,
	taillePlateau/1,
	nbJoueurs/1.
:-[ia].
:-[plateau].
:-[joueurs].
:-[ihm].


jouer(_):- gameover, !, write('Game is Over.').
jouer(IndexJoueur) :-
	taillePlateau(TaillePlateau),
	displayBoard(TaillePlateau),
	(
		not(joueursSav(IndexJoueur,-1))
	;
		% ia next move
		% jouer next move (deplacer, poser, rien)
		write("On jouera dans le futur")
	)
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
	% Initialisation des relges de deplacement
	initIndex(TaillePlateau),
	% server(8000),
	jouer(0).

stop:-
	stopServer(8000).
	
	
%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

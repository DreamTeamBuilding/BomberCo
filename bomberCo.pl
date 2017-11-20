:- dynamic 
	plateauSav/1, 
	joueursSav/2,%joueurs(Positions, Etats)
	bombes/2,%bombes(Positions, TempsRestant)
	indexAction/2,
	taillePlateau/1,
	nbJoueurs/1.
% Globales var : taillePlateau et nbJoueurs


:-[ia].
:-[plateau].
:-[joueurs].

jouer(_):- gameover, !, write('Game is Over.').
jouer(IndexJoueur) :-
	taillePlateau(TaillePlateau),
	displayBoard(TaillePlateau),
	joueursSav(Positions, Etats),
	(
		not((nth0(IndexJoueur,Etats,X), var(X)))
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
	jouer(0).

%%%%% Fin de jeu :
gameover:-false.
	/*joueursSav(_,Etats),compteSurvivants(X,Etats),X<2.*/

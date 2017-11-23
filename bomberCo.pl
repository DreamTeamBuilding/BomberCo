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

% Condition d'arret : 10 itérations

%jouer:- (gameover;tourActuel(50)), !, retract(fin(0)),assert(fin(1)).
jouer:- (gameover;tourActuel(50)), !, taillePlateau(TaillePlateau), displayBoard(TaillePlateau), writeln('Game is Over.'),retract(fin(0)),assert(fin(1)).
jouer :-
	joueurActuel(IdJoueur),
	
	taillePlateau(TaillePlateau),
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
	
	jouer
	% Delay pour les fps, wow, such graphismsz
	.

%%%%% Start !
init(NbJoueurs, TaillePlateau) :-
	initGame(NbJoueurs, TaillePlateau),
	%server(8000),
    lancerPartie
	.

initGame(NbJoueurs, TaillePlateau) :-
	assert(fin(0)),
    % Initialisation du plateau
	initPlateau(TaillePlateau),
	% Initialisation Player
	initJoueurs(NbJoueurs, TaillePlateau),
	% Initialisation des bombes
	initBombes,
	% Initialisation des regles de deplacement
	initIndex(TaillePlateau).
	
lancerPartie:-
	(fin(_) -> retractall(fin(_)); true),
	(joueurActuel(_) -> retractall(joueurActuel(_)); true),
	(tourActuel(_) -> retractall(tourActuel(_)); true),
	assert(fin(0)),
	assert(joueurActuel(0)),
	assert(tourActuel(0)),
	jouer.



stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).
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
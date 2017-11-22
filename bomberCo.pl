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
:-[bombes].
:-[ihm].
:-[tests].

% Condition d'arret : 10 itérations
%jouer(_):- gameover, !, write('Game is Over.').
jouer(_,I):- I==20, !, write('Game is Over.').
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
		% Debug
		% afficherLesDetails(IdJoueur, NewPosJoueur, BombePosee),
		actualiserJoueur(IdJoueur,NewPosJoueur),
		(BombePosee==1 -> ajouterBombe(NewPosJoueur); true)
		% ia next move
		% jouer next move (deplacer, poser, rien)
	),
	decrementerBombes,
	% Decrementer bombes,
	% Tuer des gens,
	% Actualiser NextPlayer
	% Play next player
	joueurSuivant(IdJoueur,IdJoueurSuivant),
	jouer(IdJoueurSuivant,J)
	% Delay pour les fps, wow, such graphismsz
	.

%%%%% Start !
init(NbJoueurs, TaillePlateau) :-
    % Initialisation du plateau
	initPlateau(TaillePlateau),
  % Initialisation Player
  initJoueurs(NbJoueurs, TaillePlateau),
	% Initialisation des bombes
	initBombes,
	% Initialisation des regles de deplacement
	initIndex(TaillePlateau),
	%server(8000),
	jouer(0,0).

stop:-
	stopServer(8000).

%Appel des tests unitaires
tests:- run_tests.

showCoverage:-show_coverage(run_tests).

%%%%% Fin de jeu :
gameover:-not(plusieursEnVie).

moveJ1:-retract(joueursSav(0,Y,X)),YNext is Y+1,assert(joueursSav(0,YNext,X)).



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

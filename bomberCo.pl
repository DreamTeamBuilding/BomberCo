:- dynamic plateau/1.
:- dynamic nbJoueurs/1.
:- dynamic joueurs/2. %joueurs(Positions, Etats)
:- dynamic bombes/2. %bombes(Positions, TempsRestant)
:-[ia].
:-[plateau].

play(_):- gameover, !, write('Game is Over.').
play(IndexPlayer) :-
	%Display le plateau
	joueurs(Positions, Etats),
	(
		not((nth0(IndexPlayer,Etats,X), var(X)))
	;
		% ia next move
		% play next move (deplacer, poser, rien)
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
    %Initialisation du plateau
	initPlateau(TaillePlateau),
    %Initialisation Player
    (initJoueurs(NbJoueurs, TaillePlateau) ; writeln("Erreur lors de l'initialisation des joueurs")),
	play(0).

%%%%% Positionne les joueurs dans les coins du plateau
initJoueurs(NbJoueurs, TaillePlateau):-
	length(Joueurs,NbJoueurs),
    length(PlayersState,NbJoueurs),
	(NbJoueurs < 5,NbJoueurs >1),
	nth0(0, Joueurs, Position), Position is TaillePlateau +1,
	nth0(1, Joueurs, Position2), Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2,
	(NbJoueurs < 3 ; (nth0(2, Joueurs, Position3), Position3 is TaillePlateau*2-2)),
	(NbJoueurs < 4 ; (nth0(3, Joueurs, Position4), Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1)),
    print(Joueurs),
    assert(joueurs(Joueurs,PlayersState)),
	assert(nbJoueurs(NbJoueurs)).

%%%%% Fin de jeu :
gameover:-
	joueurs(_,Etats),survivants(X,Etats),X<2.

survivants(0,[]).
survivants(NbVivants,[X|Joueurs]):- survivants(NbVivantsPrec,Joueurs),
	(var(X) -> NbVivants is NbVivantsPrec +1; NbVivants is NbVivantsPrec).

print([]).
print([X|T]):- write(X),write(','),print(T).

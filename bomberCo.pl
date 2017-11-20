:- dynamic board/1.
:- dynamic nbJoueurs/1.
:- dynamic players/2. %players(Positions, States)
:- dynamic bombs/2. %bombs(Positions, TimeLeft)
[ia].

play(_):- gameover, !, write('Game is Over.').
play(IndexPlayer) :-
	%Display le board
	players(Positions, States),
	(
		not((nth0(IndexPlayer,States,X), var(X)))
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
init(NbPlayers, TaillePlateau) :-
    %Initialisation du plateau
    length(Board,Taille),
    Taille is TaillePlateau * TaillePlateau,
    assert(board(Board)),
    %Initialisation Player
    (initPlayers(NbPlayers, TaillePlateau) ; writeln("Erreur lors de l'initialisation des joueurs")),
	play(0).

%%%%% Positionne les joueurs dans les coins du plateau
initPlayers(NbPlayers, TaillePlateau):-
	length(Players,NbPlayers),
    length(PlayersState,NbPlayers),
	(NbPlayers < 5,NbPlayers >1),
	nth0(0, Players, Position), Position is TaillePlateau +1,
	nth0(1, Players, Position2), Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2,
	(NbPlayers < 3 ; (nth0(2, Players, Position3), Position3 is TaillePlateau*2-2)),
	(NbPlayers < 4 ; (nth0(3, Players, Position4), Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1)),
    print(Players),
    assert(players(Players,PlayersState)),
	assert(nbJoueurs(NbPlayers)).

%%%%% Fin de jeu :
gameover:-
	players(_,States),survivors(X,States),X<2.

survivors(0,[]).
survivors(NbVivants,[X|Joueurs]):- survivors(NbVivantsPrec,Joueurs),
	(var(X) -> NbVivants is NbVivantsPrec +1; NbVivants is NbVivantsPrec).

print([]).
print([X|T]):- write(X),write(','),print(T).

:- dynamic board/1.
:- dynamic players/1.

%play(IndexPlayer).


%%%%% Start !
init(NbPlayers, TaillePlateau) :-
    %Initialisation du plateau
    length(Board,Taille),
    Taille is TaillePlateau * TaillePlateau,
    assert(board(Board)),
    %Initialisation Player
    (initPlayers(NbPlayers, TaillePlateau) ; writeln("Erreur lors de l'initialisation des joueurs")).

initPlayers(NbPlayers, TaillePlateau):-
    length(Players,NbPlayers),      
	(NbPlayers < 5,NbPlayers >1),
	nth0(0, Players, Position), Position is TaillePlateau +1,
	nth0(1, Players, Position2), Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2,
	(NbPlayers < 3 ; (nth0(2, Players, Position3), Position3 is TaillePlateau*2-2)),
	(NbPlayers < 4 ; (nth0(3, Players, Position4), Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1)),
    print(Players),
    assert(players(Players)).



print([]).
print([X|T]):- write(X),write(','),print(T).

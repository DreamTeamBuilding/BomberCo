%%%% Artificial intelligence: choose in a Board the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:
index(1,-11).	% haut
index(2,11).	% bas
index(3,1).	% droite
index(4,-1).	% gauche
index(5,0).	% immobile
index(6,0).	% bombe

posSafe(Index, Board) :-


% iav1 : fait tout de maniere random
ia(Board, PosIndex, Move, iav1) :- repeat, Move is random(7), index(Move, I), NewPosIndex is PosIndex+I, nth0(NewPosIndex, Board, Occupe), not(var(Occupe)), !.

% iav2 : detecte les zones de danger des bombes et bouge de maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, Move, iav2) :- repeat, (posSafe(PosIndex, Board) -> repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board); Move is random(5),index(Move, I), NewPosIndex is PosIndex+I), nth0(NewPosIndex, Board, Occupe), not(var(Occupe)), !.

% iav3 : detecte les zones de danger et cherche a s'en eloigner
ia(Board, PosIndex, Move, iav3):-
    repeat, (posSafe(PosIndex, Board) ->
            repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board);
            Move is random(5),index(Move, I), NewPosIndex is PosIndex+I),
    nth0(NewPosIndex, Board, Occupe), not(var(Occupe)), !.

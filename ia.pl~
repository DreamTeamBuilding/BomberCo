%%%% Artificial intelligence: choose in a Board the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:
Index(1,-11).	% haut
Index(2,11).	% bas
Index(3,1).		% droite
Index(4,-1).  	% gauche
Index(5,0).		% immobile
Index(6,0).		% bombe

% iav1 : fais tout de manière random
ia(Board, PosIndex, Move, iav1) :- repeat, Move is random(7), Index(Move, I), NewPosIndex is PosIndex+I, nth0(NewPosIndex, Board, Occupe), not(var(Occupe)), !.

% iav2 : détecte les zones de danger des bombes et bouge de manière random tant qu'elle n'est pas sortie
ia(Board, PosIndex, Move, iav2) :- repeat, (posSafe(PosIndex, Board) -> repeat, Move is random(7),Index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board); Move is random(5),Index(Move, I), NewPosIndex is PosIndex+I), nth0(NewPosIndex, Board, Occupe), not(var(Occupe)), !.

% iav3 : détecte les zones de danger et cherche à s'en éloigner
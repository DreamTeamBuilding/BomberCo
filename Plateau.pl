%:- dynamic plateau/1.

creerPlateau(TailleCote):-
	% Nettoyer le plateau s'il existe d'une execution precedente
	(not(plateau(_)) ; retract(plateau(_))),
	% Instancie le nouveau plateau
	TaillePlateau is TailleCote * TailleCote,
	length(Plateau, TaillePlateau),
	% On le remplit et le sav
	fill(Plateau, TailleCote, 0),
	displayBoard(TailleCote).	
	
	
displayBoard(TailleCote):-
	plateau(B),
	writeln('-----------'),
	printElementBoard(B,TailleCote,0),
	writeln('-----------'), nl.
	
	
printElementBoard([],_,_).
printElementBoard([X|Plateau],TailleCote,Index) :-
	writeVal(X),
	IndexSuivant is Index + 1,
	Mod is mod(IndexSuivant, TailleCote),
	(Mod\==0 ; writeln(' ')),
	printElementBoard(Plateau,TailleCote,IndexSuivant).

% TODO : changer pour lire les numeros et afficher les valeurs.
writeVal(Val) :- 
	(var(Val), write(' ')) ; 
	write(Val).

% TODO : changer pour mettre des numeros comme definis precedemment.
fill(Plateau,TailleCote,Fin):- Fin is TailleCote * TailleCote, assert(plateau(Plateau)).
fill(Plateau, TailleCote, IndexActuel):- 
	IndexSuivant is IndexActuel + 1,
	(
		Mod is mod(IndexSuivant, TailleCote),
		% Si on est sur la premiere ligne
		(IndexActuel<TailleCote ; 
		% Si on est sur la derniere ligne
		IndexActuel>(TailleCote*(TailleCote-1)-1)  ;
		% Si on est sur la premiere case
		Mod==1 ;
		% Si on est sur la derniere case
		Mod==0)
	-> 
		Value = 'X' 
	; 
		Value = '_'
	),
	nth0(IndexActuel,Plateau,Value),
	fill(Plateau,TailleCote,IndexSuivant).



/*printBoard(TailleCote, TailleCote).
printBoard(TailleCote, Index):-
	printLine(Index, TailleCote, 0),
	IndexSuiv is Index+1,
	printBoard(TailleCote, IndexSuiv).
	
printLine(Line, TailleCote, TailleCote):-nl.
printLine(Line, TailleCote, IndexInLine):-
	Index is Line*TailleCote + IndexInLine,
	printVal(Index),
	NextIndex is IndexInLine+1,
	printLine(Line, TailleCote, NextIndex).

printVal(N) :- plateau(B), nth0(N,B,Val), var(Val), write(' '), !.
printVal(N) :- plateau(B), nth0(N,B,Val), write(Val).*/

/*
fill(Plateau, NewBoard, TailleCote):-
	fillLine(Plateau, NewBoard, TailleCote, 0, 0).

fillLine(Plateau, NewBoard, TailleCote, Line, TailleCote).
fillLine(Plateau, NewBoard, TailleCote, Line, Index):- 
	Plateau = NewBoard,
	Current is TailleCote*Line+Index, 
	nth0(Current, NewBoard, 'X'),
	IndexSuiv is Index+1,
	fillLine(Plateau, NewBoard, TailleCote, Line, IndexSuiv).
	*/
	
% applyNewBoard(Plateau,NewBoard) :- retract(plateau(Plateau)), assert(plateau(NewBoard)).
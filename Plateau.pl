:- dynamic board/1.

creerPlateau(TailleCote):-
	TaillePlateau is TailleCote * TailleCote,
	length(Board, TaillePlateau),
	assert(board(Board)),
	fill(Board, NewBoard, TailleCote),
	applyIt(Board, NewBoard),
	displayBoard(TailleCote),
	retract(board(Board)).	
	
	
displayBoard(TailleCote):-
	writeln('-----------'),
	printBoard(TailleCote, 0),
	writeln('-----------'), nl.
	
printBoard(TailleCote, TailleCote).
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

printVal(N) :- board(B), nth0(N,B,Val), var(Val), write(' '), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).

fill(Board, NewBoard, TailleCote):-
	fillLine(Board, NewBoard, TailleCote, 0, 0).

fillLine(Board, NewBoard, TailleCote, Line, TailleCote).
fillLine(Board, NewBoard, TailleCote, Line, Index):- 
	Board = NewBoard,
	Current is TailleCote*Line+Index, 
	nth0(Current, NewBoard, 'X'),
	IndexSuiv is Index+1,
	fillLine(Board, NewBoard, TailleCote, Line, IndexSuiv).
	
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).
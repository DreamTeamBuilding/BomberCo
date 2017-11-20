:- dynamic board/1.

creerPlateau(TailleCote):-
	TaillePlateau is TailleCote * TailleCote,
	length(Board, TaillePlateau),
	assert(board(Board)),
	fill(Board, NewBoard, TailleCote),
	applyIt(Board, NewBoard),
	displayBoard(TailleCote),
	retract(board(Board)).	
	
% Affichage du plateau
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


% Remplissage du plateau
fill(Board, NewBoard, TailleCote):-
	fillLine(Board, NewBoard, TailleCote, 0, 0),
	fillColumn(Board, NewBoard, TailleCote, 1, 0),
	fillColumn(Board, NewBoard, TailleCote, 1, TailleCote-1),
	fillLine(Board, NewBoard, TailleCote, TailleCote-1, 0).
	%fillObstacles(Board, NewBoard, TailleCote, 0, 0).

fillLine(Board, NewBoard, TailleCote, Line, TailleCote).
fillLine(Board, NewBoard, TailleCote, Line, Index):- 
	Board = NewBoard,
	Current is TailleCote*Line+Index, 
	nth0(Current, NewBoard, 1),
	IndexSuiv is Index+1,
	fillLine(Board, NewBoard, TailleCote, Line, IndexSuiv).
	
	
fillColumn(Board, NewBoard, TailleCote, TailleCote, Column).
fillColumn(Board, NewBoard, TailleCote, Index, Column):- 
	Board = NewBoard,
	Current is TailleCote*Index+Column, 
	nth0(Current, NewBoard, 1),
	IndexSuiv is Index+1,
	fillColumn(Board, NewBoard, TailleCote, IndexSuiv, Column).
	
%fillObstacles(Board, NewBoard, TailleCote, TailleCote, TailleCote).
%fillObstacles(Board, NewBoard, TailleCote, Index, TailleCote):-
%	IndexSuiv is Index+2,
%	fillObstacles(Board, NewBoard, TailleCote, IndexSuiv, 0).
%fillObstacles(Board, NewBoard, TailleCote, Line, Index):- 
%	Board = NewBoard,
%	Current is TailleCote*Line+Index, 
%	nth0(Current, NewBoard, 1),
%	IndexSuiv is Index+1,
%	print(IndexSuiv),
%	fillObstacles(Board, NewBoard, TailleCote, Line, IndexSuiv).

	
% 
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).
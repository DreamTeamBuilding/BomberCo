initPlateau(TailleCote):-
	% Nettoyer le plateau s'il existe d'une execution precedente
	(not(plateauSav(_));retract(plateauSav(_))),
	% Instancie le nouveau plateau
	TaillePlateau is TailleCote * TailleCote,
	length(Plateau, TaillePlateau),
	% On le remplit et le sav
	fill(Plateau, TailleCote, 0).	
	
	
displayBoard(TailleCote):-
	plateauSav(B),
	printElementBoard(B,TailleCote,0),nl.
	
	
printElementBoard([],_,_).
printElementBoard([X|Plateau],TailleCote,Index) :-
	%bombes(PosBombes,_),
	(
	(joueursSav(Index,Etat), Etat is -1) -> write('P'); 
	joueursSav(Index,_) -> write('..'); 
	writeVal(X)
	),
	IndexSuivant is Index + 1,
	Mod is mod(IndexSuivant, TailleCote),
	(Mod\==0 ; writeln(' ')),
	printElementBoard(Plateau,TailleCote,IndexSuivant).

writeVal(Val) :- 
	(var(Val), write(' ')) ; 
	(Val==0, write('_')) ;
	(Val==1, write('X')).

fill(Plateau,TailleCote,Fin):- 
	Fin is TailleCote * TailleCote,  
	assert(plateauSav(Plateau)).
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
		Value = 1 
	; 
		Value = 0
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
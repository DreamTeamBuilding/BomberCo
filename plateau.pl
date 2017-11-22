initPlateau(TailleCote):-
	% Nettoyer le plateau s'il existe d'une execution precedente
	(not(plateauSav(_));retract(plateauSav(_))),
	% Instancie le nouveau plateau
	TaillePlateau is TailleCote * TailleCote,
	length(Plateau, TaillePlateau),
	% On le remplit et le sav
	fill(Plateau, TailleCote, 0).

% Affichage du plateau
displayBoard(TailleCote):-
	plateauSav(B),
	printElementBoard(B,TailleCote,0),nl.


printElementBoard([],_,_).
printElementBoard([X|Plateau],TailleCote,Index) :-
	%bombes(PosBombes,_),
	(
	(joueursSav(_,Index,Etat), Etat is -1) -> write('P');
	joueursSav(_,Index,_) -> write('..'); 
	bombes(Index,_) -> write('o');

	(bombes(Index, TempsRestant), TempsRestant==0) -> write('O');

	(bombes(Index-2, TempsRestant), TempsRestant==0) -> write('+');
	(bombes(Index-1, TempsRestant), TempsRestant==0) -> write('+');
	(bombes(Index+1, TempsRestant), TempsRestant==0) -> write('+');
	(bombes(Index+2, TempsRestant), TempsRestant==0) -> write('+');

	(bombes(Index-22, TempsRestant), TempsRestant==0) -> write('+');
	(bombes(Index-11, TempsRestant), TempsRestant==0) -> write('+');
	(bombes(Index+11, TempsRestant), TempsRestant==0) -> write('+');
	(bombes(Index+22, TempsRestant), TempsRestant==0) -> write('+');

	writeVal(X)
	),
	IndexSuivant is Index + 1,
	Mod is mod(IndexSuivant, TailleCote),
	(Mod\==0 ; writeln(' ')),
	printElementBoard(Plateau,TailleCote,IndexSuivant).

writeVal(Val) :-
	(var(Val), write(' ')) ;
	(Val==0, write('  ')) ;
	(Val==1, write('X')).

fill(Plateau,TailleCote,Fin):-
	Fin is TailleCote * TailleCote,
	assert(plateauSav(Plateau)).

fill(Plateau, TailleCote, IndexActuel):-
	IndexSuivant is IndexActuel + 1,
	(
		Mod is mod(IndexSuivant, TailleCote),
		ColImpair is mod(IndexSuivant, 2),
		LigImpair is mod(IndexSuivant, TailleCote+TailleCote),
		% Si on est sur la premiere ligne
		(IndexActuel<TailleCote ;
		% Si on est sur la derniere ligne
		IndexActuel>(TailleCote*(TailleCote-1)-1)  ;
		% Si on est sur la premiere case
		Mod==1 ;
		% Si on est sur la derniere case
		Mod==0 ;
		% Si on est sur cases dont colonnes impaire + ligne impaire
		(ColImpair==1, LigImpair>=1, LigImpair=<TailleCote)
		)
	->
		Value = 1
	;
		Value = 0
	),
	nth0(IndexActuel,Plateau,Value),
	fill(Plateau,TailleCote,IndexSuivant).

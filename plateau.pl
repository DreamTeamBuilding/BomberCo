initPlateau(TailleCote):-
	(taillePlateau(_) -> retractall(taillePlateau(_)); true),
	assert(taillePlateau(TailleCote)),
	(plateauSav(_) -> retractall(plateauSav(_)); true),
	% Instancie le nouveau plateau
	TaillePlateau is TailleCote * TailleCote,
	length(Plateau, TaillePlateau),
	% On le remplit et le sav
	fill(Plateau, TailleCote, 0).


% Affichage du plateau
displayBoard(TailleCote):-
	plateauSav(B),
	printElementBoard(B,TailleCote,0),nl.


printElementBoard([],_,_):-!.
printElementBoard([X|Plateau],TailleCote,Index) :-
	(
	(X==1, write('X'));
	((joueursSav(_,Index,Etat), Etat is -1) -> write('P');false);
	(joueursSav(_,Index,_) -> write('.');false);
	((bombes(Index, TempsRest), TempsRest>=0) -> write('o');false);
	((bombes(Index, TempsRest), TempsRest<0) -> write('+');false);
	(X==0, write(' '));
	(X==1, write('X'))
	),!,
	IndexSuivant is Index + 1,
	Mod is mod(IndexSuivant, TailleCote),
	(Mod==0 -> writeln(' ') ; true),
	printElementBoard(Plateau,TailleCote,IndexSuivant).

fill(Plateau,TailleCote,Fin):-
	Fin is TailleCote * TailleCote,!,
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
		)->
		Value = 1
	;
		Value = 0
	),
	nth0(IndexActuel,Plateau,Value),
	fill(Plateau,TailleCote,IndexSuivant).

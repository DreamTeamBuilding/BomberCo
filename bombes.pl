initBombes:-
	(porteeBombes(_) -> retractall(porteeBombes(_)); true),
	assert(porteeBombes(2)),
	bombes(_,_) -> retractall(bombes(_,_)); true.

ajouterBombe(Position):-
  nbJoueurs(NbJoueurs),
  Duree is NbJoueurs*5,
  assert(bombes(Position, Duree)).

decrementerBombes:-
  findall(Temps,bombes(_, Temps), ListeTemps),
  findall(Pos,bombes(Pos,_),ListePos),
  decrementerListe(ListeTemps, _, ListePos).

decrementerListe([],[],[]):-!.
decrementerListe([X|Liste], [Y|ListeDec], [Pos|ListePos]):-
  Y is X-1,
  retract(bombes(Pos, _)),
  (Y>=0 -> assert(bombes(Pos, Y)) ; true),
decrementerListe(Liste, ListeDec, ListePos).

exploserBombes:-
 	findall(IndexBombes,bombes(IndexBombes,0),ListesBombes),
 	exploserBombes(ListesBombes),!.

exploserBombes([]):-!.
exploserBombes([BombesAEXploser|Autres]):-
	taillePlateau(TaillePlateau),
	porteeBombes(PorteeBombes),
	exploserGauche(BombesAEXploser, 1, PorteeBombes),
	exploserDroite(BombesAEXploser, 1, PorteeBombes),
	exploserBas(BombesAEXploser, 1, PorteeBombes, TaillePlateau),
	exploserHaut(BombesAEXploser, 1, PorteeBombes, TaillePlateau),
	exploserBombes(Autres).


exploserGauche(IndexBombe, Rang, PorteeBombes):-
	plateauSav(Plateau),
	Index is (IndexBombe-Rang), 
	nth0(Index, Plateau, Val), 
	(Val\==1 ->
		ajouterExplosion(Index),
		(joueursSav(Id, Index, _) -> tuer(Id) ; true),
		((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserGauche(IndexBombe, RangSuiv, PorteeBombes)) ; true)
	; 
		true
	).

exploserDroite(IndexBombe, Rang, PorteeBombes):-
	plateauSav(Plateau),
	Index is (IndexBombe+Rang),
	nth0(Index, Plateau, Val),
	(Val\==1 -> 
		ajouterExplosion(Index),
		(joueursSav(Id, Index, _) -> tuer(Id) ; true),
		((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserDroite(IndexBombe, RangSuiv, PorteeBombes)) ; true)
	; 
		true
	).

exploserBas(IndexBombe, Rang, PorteeBombes, TaillePlateau):-
	plateauSav(Plateau),
	Index is (IndexBombe+Rang*TaillePlateau), 
	nth0(Index, Plateau, Val), 
	(Val\==1 ->
		ajouterExplosion(Index),
		(joueursSav(Id, Index, _) -> tuer(Id) ; true),
		((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserBas(IndexBombe, RangSuiv, PorteeBombes, TaillePlateau)) ; true) 
	; 
		true
	).

exploserHaut(IndexBombe, Rang, PorteeBombes, TaillePlateau):-
	plateauSav(Plateau),
	Index is (IndexBombe-Rang*TaillePlateau), 
	nth0(Index, Plateau, Val) ,
	(Val\==1 -> ajouterExplosion(Index),
		(joueursSav(Id, Index, _) -> tuer(Id) ; true),
		((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserHaut(IndexBombe, RangSuiv, PorteeBombes, TaillePlateau)) ; true) 
	; 
		true
	).

ajouterExplosion(Index):-
	assert(bombes(Index, -1)).

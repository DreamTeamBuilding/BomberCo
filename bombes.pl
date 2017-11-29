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

decrementerListe([],[],[]).
decrementerListe([X|Liste], [Y|ListeDec], [Pos|ListePos]):-
  Y is X-1,
  retract(bombes(Pos, _)),
  (Y>=0 -> assert(bombes(Pos, Y)) ; true),
decrementerListe(Liste, ListeDec, ListePos).

/*
A virer
*//*
exploserBombes:-
 	findall(IdJoueur,joueursSav(IdJoueur,_,_),ListeId),
 % TODO : Oh c'est moche!!
 % J'ai rajouté mon botox - Lulu Swag
 	exploserBombes(ListeId).
 
 exploserBombes([]).
 exploserBombes([Id|Ids]):-
 	taillePlateau(TaillePlateau),
 	plateauSav(Plateau),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-1), bombes(PositionB, 0), tuer(Id)) ; true),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-2), PositionE is PositionJ-1, nth0(PositionE, Plateau, 0), bombes(PositionB, 0), tuer(Id)) ; true),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+1), bombes(PositionB, 0), tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+2), PositionE is PositionJ+1, nth0(PositionE, Plateau, 0), bombes(PositionB, 0), tuer(Id)) ; true),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-TaillePlateau), bombes(PositionB, 0), tuer(Id)) ; true),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-2*TaillePlateau), PositionE is PositionJ-TaillePlateau, nth0(PositionE, Plateau, 0), bombes(PositionB, 0), tuer(Id)) ; true),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+TaillePlateau), bombes(PositionB, 0), tuer(Id)) ; true),
 	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+2*TaillePlateau), PositionE is PositionJ+TaillePlateau, nth0(PositionE, Plateau, 0), bombes(PositionB, 0), tuer(Id)) ; true),
 	exploserBombes(Ids).
 */
 
/*
A garder
*/
exploserBombes:-
 	findall(IndexBombes,bombes(IndexBombes,0),ListesBombes),
 	exploserBombes(ListesBombes).

exploserBombes([]).
exploserBombes([BombesAEXploser|Autres]):-
	taillePlateau(TaillePlateau),
	porteeBombes(PorteeBombes),
	PremierRang is (1),
	exploserGauche(BombesAEXploser, PremierRang, PorteeBombes),
	exploserDroite(BombesAEXploser, PremierRang, PorteeBombes),
	exploserBas(BombesAEXploser, PremierRang, PorteeBombes, TaillePlateau),
	exploserHaut(BombesAEXploser, PremierRang, PorteeBombes, TaillePlateau),
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

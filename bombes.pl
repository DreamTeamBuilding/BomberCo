initBombes:-
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

exploserBombes:-
	taillePlateau(TaillePlateau),
	porteeBombes(PorteeBombes),
	PremierRang is (1),
	exploserGauche(PremierRang, PorteeBombes),
	PremierRang is (1),
	exploserDroite(PremierRang, PorteeBombes),
	PremierRang is (1),
	exploserBas(PremierRang, PorteeBombes, TaillePlateau),
	PremierRang is (1),
	exploserHaut(PremierRang, PorteeBombes, TaillePlateau).

exploserGauche(Rang, PorteeBombes):-
	plateauSav(Plateau),
	(bombes(PositionB, 0), Index is (PositionB-Rang), nth0(Index, Plateau, Val), Val\==1, ajouterExplosion(Index),
	((joueursSav(Id, Index, 0), tuer(Id)) ; true),
	((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserGauche(RangSuiv, PorteeBombes)))) ; true.

exploserDroite(Rang, PorteeBombes):-
	plateauSav(Plateau),
	(bombes(PositionB, 0), Index is (PositionB+Rang), nth0(Index, Plateau, Val), Val\==1, ajouterExplosion(Index),
	((joueursSav(Id, Index, 0), tuer(Id)) ; true),
	((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserDroite(RangSuiv, PorteeBombes)))) ; true.

exploserBas(Rang, PorteeBombes, TaillePlateau):-
	plateauSav(Plateau),
	(bombes(PositionB, 0), Index is (PositionB+Rang*TaillePlateau), nth0(Index, Plateau, Val), Val\==1, ajouterExplosion(Index),
	((joueursSav(Id, Index, 0), tuer(Id)) ; true),
	((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserBas(RangSuiv, PorteeBombes, TaillePlateau)))) ; true.

exploserHaut(Rang, PorteeBombes, TaillePlateau):-
	plateauSav(Plateau),
	(bombes(PositionB, 0), Index is (PositionB-Rang*TaillePlateau), nth0(Index, Plateau, Val), Val\==1, ajouterExplosion(Index),
	((joueursSav(Id, Index, 0), tuer(Id)) ; true),
	((Rang\==PorteeBombes) -> (RangSuiv is Rang+1, exploserHaut(RangSuiv, PorteeBombes, TaillePlateau)))) ; true.

ajouterExplosion(Index):-
	assert(bombes(Index, -1)).

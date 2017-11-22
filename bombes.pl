initBombes:-
	not(bombes(_,_)) ; retractall(bombes(_,_)).

ajouterBombe(Position):-
  nbJoueurs(NbJoueurs),
  Duree is NbJoueurs*3,
  assert(bombes(Position, Duree)).

decrementerBombes:-
  findall(Temps,bombes(_, Temps), ListeTemps),
  findall(Pos,bombes(Pos,_),ListePos),
  decrementerListe(ListeTemps, ListeTempsDec, ListePos).

decrementerListe([],[],[]).
decrementerListe([X|Liste], [Y|ListeDec], [Pos|ListePos]):-
  Y is X-1,
  retract(bombes(Pos, _)),
  (Y>=0 -> assert(bombes(Pos, Y)) ; true),
decrementerListe(Liste, ListeDec, ListePos).

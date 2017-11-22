initBombes:-
	not(bombes(_,_)) ; retractall(bombes(_,_)).

ajouterBombe(Position):-
  nbJoueurs(NbJoueurs),
  Duree is NbJoueurs*3,
  assert(bombes(Position,Duree)).

decrementerBombes:-
  findall(Temps,bombes(_,Temps),ListeTemps),
  decrementerListe(ListeTemps, ListeTempsDec).

decrementerListe([],[]).
decrementerListe([X|Liste],[Y|ListeDec]):-
  Y is X-1, decrementerListe(Liste,ListeDec).

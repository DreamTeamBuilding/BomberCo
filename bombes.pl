initBombes:-
	not(bombes(_,_)) ; retractall(bombes(_,_)).

ajouterBombe(Position):-
  nbJoueurs(NbJoueurs),
  assert(bombes(Position,NbJoueurs*3)).

decrementerBombes:-
  findall(Temps,bombes(_,Temps),ListeTemps).


evalIa(0, _, _, _, _, _, _):- !.
evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, Ia1, Ia2):-
	NewIter is NbIter-1,
	lancerPartie(2,TaillePlateau,Ia1,Ia2),
	statistics(walltime, [_ | [_]]),
	jouer, !,
	statistics(walltime, [_ | [ExecutionTime]]),
	(joueursSav(Looser, _, 0) -> 
		%Ajout looser a la liste
		nth0(NewIter, Defaites, Looser)	 
	 ;
	  	nth0(NewIter, Defaites, -1)),
	tourActuel(NombreTour), 
	%Ajout nombre tour a la liste
	nth0(NewIter, NombresTours, NombreTour),
	%Ajout ExecutionTime a la liste
	nth0(NewIter, TempsMs, ExecutionTime),
	evalIa(NewIter,Defaites,NombresTours, TempsMs, TaillePlateau, Ia1, Ia2).


sum([Item], Item):- !.
sum([Item1,Item2 | Tail], Total) :-
    sum([Item1+Item2|Tail], Total).

average(List, Average):- 
    sum(List, Sum),
    length(List, Length),
    Length > 0, 
    Average is Sum / Length.

statNbTour(NombresTours):-
	average(NombresTours, MoyNombreTours),
	write("Moy nombre tour : "),
	writeln(MoyNombreTours).


statTempsMoy(TempsMs):-
	average(TempsMs, MoyTempsMs),
	write("Moy temps ms : "),
	writeln(MoyTempsMs).

statDefaites(J1, J2, Defaites):-
	count(J1, Defaites, DefaitesJ1),
	count(J2, Defaites, DefaitesJ2),
	count(-1, Defaites, Egalites),
	write("J1 a perdu : "), write(DefaitesJ1), writeln(" fois."),
	write("J2 a perdu : "), write(DefaitesJ2), writeln(" fois."),
	write("Il y a eu "), write(Egalites), writeln(" egalites."),
	((DefaitesJ2 =< DefaitesJ1) ->
		writeln("J2 est meilleur")
		;
		writeln("J1 est meilleur")),
	!. 
	%Pas une égalité du style "ils sont morts tous les 2 en meme temps"
	%ce cas n'est pas gere, on parle d'egalite "le timer a fini et personne n'est mort"

count(_, [], 0) :- !.
count(X, [X|T], N) :-
    count(X, T, N2), 
    N is N2 + 1.
count(X, [Y|T], N) :-
    X \= Y,
    count(X, T, N).

ia1vsia2:-
	writeln("-------IA1 vs IA2-------"),
	writeln("J1 est ia1"),
	writeln("J2 est ia2"),
	NbIter is 100,
	TaillePlateau is 11,
	length(Defaites, NbIter),
	length(NombresTours, NbIter),
	length(TempsMs, NbIter),
	evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, 1, 2),
	statNbTour(NombresTours),
	statTempsMoy(TempsMs),
	statDefaites(0,1, Defaites).


ia1vsia3:-
	writeln("-------IA1 vs IA3-------"),
	writeln("J1 est ia1"),
	writeln("J2 est ia3"),
	NbIter is 100,
	TaillePlateau is 11,
	length(Defaites, NbIter),
	length(NombresTours, NbIter),
	length(TempsMs, NbIter),
	evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, 1, 3),
	statNbTour(NombresTours),
	statTempsMoy(TempsMs),
	statDefaites(0,1, Defaites).

ia1vsia4:-
	writeln("-------IA1 vs IA4-------"),
	writeln("J1 est ia1"),
	writeln("J2 est ia4"),
	NbIter is 100,
	TaillePlateau is 11,
	length(Defaites, NbIter),
	length(NombresTours, NbIter),
	length(TempsMs, NbIter),
	evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, 1, 4),
	statNbTour(NombresTours),
	statTempsMoy(TempsMs),
	statDefaites(0,1, Defaites).

ia2vsia3:-
	writeln("-------IA2 vs IA3-------"),
	writeln("J1 est ia2"),
	writeln("J2 est ia3"),
	NbIter is 100,
	TaillePlateau is 11,
	length(Defaites, NbIter),
	length(NombresTours, NbIter),
	length(TempsMs, NbIter),
	evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, 2, 3),
	statNbTour(NombresTours),
	statTempsMoy(TempsMs),
	statDefaites(0,1, Defaites).

ia2vsia4:-
	writeln("-------IA2 vs IA4-------"),
	writeln("J1 est ia2"),
	writeln("J2 est ia4"),
	NbIter is 100,
	TaillePlateau is 11,
	length(Defaites, NbIter),
	length(NombresTours, NbIter),
	length(TempsMs, NbIter),
	evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, 2, 4),
	statNbTour(NombresTours),
	statTempsMoy(TempsMs),
	statDefaites(0,1, Defaites).


ia3vsia4:-
	writeln("-------IA3 vs IA4-------"),
	writeln("J1 est ia3"),
	writeln("J2 est ia4"),
	NbIter is 100,
	TaillePlateau is 11,
	length(Defaites, NbIter),
	length(NombresTours, NbIter),
	length(TempsMs, NbIter),
	evalIa(NbIter, Defaites, NombresTours, TempsMs, TaillePlateau, 3, 4),
	statNbTour(NombresTours),
	statTempsMoy(TempsMs),
	statDefaites(0,1, Defaites).
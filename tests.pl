:-begin_tests(plateau).
test(initPlateau):-
	initPlateau(11),
	taillePlateau(11),
	plateauSav(B),
	length(B, 121),
	!.

test(fill):-
	length(Plateau, 121),
	fill(Plateau, 11, 0),
	PlateauC = ([1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1]),
	comp(Plateau, PlateauC),
	!.
	
test(writeVal):-
	writeVal(0),
	writeVal(1),
	writeVal(PasInstancie),
	!.
:- end_tests(plateau).

comp(L1, L1).


:-begin_tests(joueurs).
test(initJoueurs):-
	initJoueurs(2, 11),
	nbJoueurs(2),
	joueursSav(12, -1), 
	joueursSav(108, -1),
	!.
 
test(initJoueurs):-
	initJoueurs(4, 11),
	nbJoueurs(4),
	joueursSav(12, -1),  
	joueursSav(20, -1),
	joueursSav(100, -1),  
	joueursSav(108, -1),
	!.
	
test(initJoueurs):-
	initJoueurs(3, 11),
	nbJoueurs(3),
	joueursSav(12, -1),  
	joueursSav(20, -1),  
	joueursSav(108, -1),
	!.

test(plusieursEnVie):-
	initJoueurs(2, 11),
	plusieursEnVie,
	retract(joueursSav(108, _)),
	assert(joueursSav(108, 0)),
	not(joueursSav(108, -1)),
	not(plusieursEnVie),
	!.

:-end_tests(joueurs).


:-begin_tests(ia).
	
:-end_tests(ia).
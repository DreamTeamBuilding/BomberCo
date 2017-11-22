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
		writeVal(_),
		!.
:- end_tests(plateau).

comp(L1, L1).


:-begin_tests(joueurs).
	test(initJoueurs):-
		initJoueurs(2, 11),
		nbJoueurs(2),
		joueursSav(_, 12, -1), 
		joueursSav(_, 108, -1),
		!.
	test(initJoueurs):-
		initJoueurs(4, 11),
		nbJoueurs(4),
		joueursSav(_, 12, -1),  
		joueursSav(_, 20, -1),
		joueursSav(_, 100, -1),  
		joueursSav(_, 108, -1),
		!.
	test(initJoueurs):-
		initJoueurs(3, 11),
		nbJoueurs(3),
		joueursSav(_, 12, -1),  
		joueursSav(_, 20, -1),  
		joueursSav(_, 108, -1),
		!.
	test(plusieursEnVie):-
		initJoueurs(2, 11),
		plusieursEnVie,
		retract(joueursSav(_, 108, _)),
		assert(joueursSav(_, 108, 0)),
		not(joueursSav(_, 108, -1)),
		not(plusieursEnVie),
		!.
	test(actualiserJoueur):-
		initJoueurs(2, 11),
		actualiserJoueur(1, 13),
		joueursSav(_, 13, -1),
		!.
	test(joueurSuivant):-
		initJoueurs(2,11),
		joueurSuivant(0,1),
		joueurSuivant(1,0),
		!.
	test(joueurSuivant):-
		initJoueurs(3,11),
		joueurSuivant(0,1),
		joueurSuivant(1,2),
		joueurSuivant(2,0),
		!.
:-end_tests(joueurs).

:-begin_tests(ia).
	test(initIndex):-
		initIndex(11),
		indexAction(1,-TaillePlateau,0),
		indexAction(2, TaillePlateau,0),
		indexAction(3,1,0),
		indexAction(4,-1,0),
		indexAction(5,0,0),
		indexAction(6,0,1),
		!.
	test(distance):-
		initPlateau(11),
		ia:distance(12, 12, 0),
		ia:distance(12, 13, 1),
		ia:distance(12, 14, 2),
		ia:distance(14, 12, 2),
		ia:distance(14, 13, 1),
		ia:distance(23, 25, 2), % Entre deux cases séparées par un mur
		ia:distance(12, 23, 1), % Entre deux cases l'une sur l'autre
		ia:distance(23, 12, 1), % Entre deux cases l'une sur l'autre
		ia:distance(12, 27, 5), % Entre deux cases en diagonale
		!.
	/* test(isSafe):-
		initPlateau(11),
		plateauSav(B),
		isSafe(13, B),
		!. */
	test(isPossible):-
		initPlateau(11),
		plateauSav(B),
		initJoueurs(2, 11),
		joueursSav(0, 12, _),
		isPossible(12, 13, B),
		isPossible(12, 12, B),
		isPossible(12, 23, B),
		not(isPossible(12, 11, B)),
		not(isPossible(12, 1, B)),
		!.
		
	test(isPossible):-
		initPlateau(11),
		plateauSav(B),
		initJoueurs(2, 11),
		joueursSav(0, 12, _),
		isPossible(13, B),
		isPossible(23, B),
		not(isPossible(11, B)),
		not(isPossible(1, B)),
		!.
:-end_tests(ia).
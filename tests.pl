:-begin_tests(plateau).
	test(initPlateau):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initPlateau,
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
:-end_tests(plateau).

comp(L1, L1).


:-begin_tests(joueurs).
	test(initJoueurs):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs,
		nbJoueurs(2),
		joueursSav(_, 12, -1), 
		joueursSav(_, 108, -1),
		!.
	test(initJoueurs):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(4)),
		assert(taillePlateau(11)),
		initJoueurs,
		nbJoueurs(4),
		joueursSav(_, 12, -1),  
		joueursSav(_, 20, -1),
		joueursSav(_, 100, -1),  
		joueursSav(_, 108, -1),
		!.
	test(initJoueurs):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(3)),
		assert(taillePlateau(11)),
		initJoueurs,
		nbJoueurs(3),
		joueursSav(_, 12, -1),  
		joueursSav(_, 20, -1),  
		joueursSav(_, 108, -1),
		!.
	test(plusieursEnVie):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs,
		plusieursEnVie,
		retract(joueursSav(_, 108, _)),
		assert(joueursSav(_, 108, 0)),
		not(joueursSav(_, 108, -1)),
		not(plusieursEnVie),
		!.
	test(actualiserJoueur):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs,
		actualiserJoueur(1, 13),
		joueursSav(_, 13, -1),
		!.
	test(joueurSuivant):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs,
		joueurSuivant(0,1),
		joueurSuivant(1,0),
		!.
	test(joueurSuivant):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(3)),
		assert(taillePlateau(11)),
		initJoueurs,
		joueurSuivant(0,1),
		joueurSuivant(1,2),
		joueurSuivant(2,0),
		!.
	test(tuer):-
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs,
		tuer(0),
		joueursSav(0, _, 0),
		tuer(1),
		joueursSav(1, _, 0),
		!.
	test(exploserBombe):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		%TODO
		!.
:-end_tests(joueurs).

:-begin_tests(ia).
	test(initIndex):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initIndex,
		indexAction(1,-TaillePlateau,0),
		indexAction(2, TaillePlateau,0),
		indexAction(3,1,0),
		indexAction(4,-1,0),
		indexAction(5,0,0),
		indexAction(6,0,1),
		!.
	test(distance):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initIndex,
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
	test(isPossible):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initIndex,
		plateauSav(B),
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs,
		joueursSav(0, 12, _),
		isPossible(12, 13, B),
		isPossible(12, 12, B),
		isPossible(12, 23, B),
		not(isPossible(12, 11, B)),
		not(isPossible(12, 1, B)),
		!.
	test(isSafeTest):-
		clean_dynamic,
		assert(taillePlateau(11)),
		initIndex,
		initPlateau,
		assert(nbJoueurs(2)),
		nbJoueurs(2),
		taillePlateau(11),
		initBombes,
		plateauSav(B),
		assert(bombes(107, 1)),
		not(isSafe(108, B)),
		!.
:-end_tests(ia).

:-begin_tests(bombes).
	test(initBombes):-
		initBombes,
		not(bombes(_,_)),
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		assert(nbJoueurs(2)),
		ajouterBombe(12),
		initBombes,
		not(bombes(_,_)),
		!.
	test(ajouterBombe):-
		initBombes,
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		assert(nbJoueurs(2)),
		ajouterBombe(14),
		nbJoueurs(NbJoueurs),
		Duree is NbJoueurs * 5,
		bombes(14, Duree),
		initBombes,
		!.
	test(decrementerBombes):-
		initBombes,
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		assert(nbJoueurs(2)),
		ajouterBombe(14),
		ajouterBombe(23),
		decrementerBombes,
		bombes(14, 9),
		bombes(23, 9),
		decrementerBombes,
		bombes(14, 8),
		bombes(23, 8),
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes, % On décrémente 8 fois pour faire exploser la bombe et vérifier si elle est toujours en mémoire.
		not(bombes(14, _)),
		not(bombes(23, _)),
		initBombes,
		!.
:-end_tests(bombes).

iaMC(PosIndex, NewPosIndex, BombePosee, iaMC) :-
	joueursSav(IdJoueur,PosIndex,_),
	tourActuel(TA),
	Actions = [6,1,2,3,4,5],
	testerMeilleurCoup(Actions, ActionJouee, _ScoreDeLAction, IdJoueur, TA),
	indexAction(ActionJouee,Deplacement,BombePosee),
	NewPosIndex is PosIndex + Deplacement
	.

% Lance l'initialisation de la recherche de max
testerMeilleurCoup([PremiereAction|AutresActions], MeilleureAction, MeilleurScore,IdJoueur,TA) :-
	testerMeilleurCoup([PremiereAction|AutresActions], PremiereAction, MeilleureAction, -10000000, MeilleurScore,IdJoueur,TA). %% l'init du meilleur score est degueu ^^

% Validation du max
testerMeilleurCoup([], MeilleureAction, MeilleureAction, MeilleurScore, MeilleurScore,_,_).
% Recherche du max parmis les autres coups
testerMeilleurCoup([X|L], MeilleureAction0, MeilleureAction, MeilleurScore0, MeilleurScore,IdJoueur,TA) :-

	% test du is possible
	joueursSav(IdJoueur,PosIndex,_),
	indexAction(X,Deplacement,_),
	NewPosIndex is PosIndex + Deplacement,
	(isPossible(PosIndex,NewPosIndex) ->
		% appel des iterations pour calculer un score
		simulationMC(X, 0,ScoreTrouve,0,IdJoueur,TA),
		% tests pour le maximum
		(   ScoreTrouve > MeilleurScore0 ->
			MeilleurScore1 is ScoreTrouve, MeilleureAction1 is X
		;
			MeilleurScore1 is MeilleurScore0, MeilleureAction1 is MeilleureAction0
		)
	;
		true
	),
	testerMeilleurCoup([X|L], MeilleureAction1, MeilleureAction, MeilleurScore1, MeilleurScore,IdJoueur,TA).
	
simulationMC(_, ScoreFinal,ScoreFinal, 250,_,_) :- !.
simulationMC(Action, Score,ScoreFinal, NbIterationActuelle,IdJoueurMC,TourDebutSimulation) :-
%sauver etat
	sauverEtat(PlateauTemp,JoueursTemp,BombesTemp,JoueurActuelTemp,TourActuelTemp),
%jouer mov 1
	% deplacer le joueur sur la nouvelle Pos avant le debut de la partie simulee et creer une bombe si necessaire
	retract(joueursSav(IdJoueurMC,PosIndex,EtatJ)),
	indexAction(Action,Deplacement,BombePosee),
	NewPosIndex is PosIndex + Deplacement,
	assert(joueursSav(IdJoueurMC,NewPosIndex,EtatJ)),
	(BombePosee == 1 -> ajouterBombe(PosIndex);true),
	
%jouer jusqu'a finie
	assert(tourActuel(TourDebutSimulation)),
	jouerMC(IdGagnant),
%calcul du score
	% si Score n'est pas instancie, on l'initialise a 0
	(   var(Score) -> ScoreSuiv is 0;true),
	tourActuel(TA),
	% En cas d'egalite
	(   TA < 50 -> true ;
	(   IdGagnant == IdJoueurMC ->
	ScoreSuiv is Score+(10000/(TA*TA));% EQUILIBRAGE : tests a la main pour cette expression qui me parait pas horrible
	ScoreSuiv is Score-(7000/(TA*TA))), % EQUILIBRAGE : une défaite est moins importante qu'une victoire car une défaite peut etre évitée le moment venu et une victoire provoquée
	NbIterationSuiv is NbIterationActuelle+1, % instanciee ?
%restaurer etat
	restaurerEtat(PlateauTemp,JoueursTemp,BombesTemp,JoueurActuelTemp,TourActuelTemp),
%lancer simu suivante
	simulationMC(Action, ScoreSuiv,ScoreFinal, NbIterationSuiv,IdJoueurMC,TourDebutSimulation))
	.

sauverEtat(Plateau,Joueurs,Bombes,JoueurActuel,TourActuel):-
	plateauSav(Plateau),
	findall([X,Y,Z],joueursSav(X,Y,Z), Joueurs),
	findall([V,W],bombes(V,W),Bombes), 
	joueurActuel(JoueurActuel),
	tourActuel(TourActuel)
.

restaurerEtat(Plateau,Joueurs,Bombes,JoueurActuel,TourActuel):-
	retract(plateauSav(_)),
	retractall(joueursSav(_)),
	retractall(bombes(_)),
	retract(joueurActuel(_)),
	retract(tourActuel(_)),
	
	assert(plateauSav(Plateau)),
	restaurerJoueurs(Joueurs),
	restaurerBombes(Bombes),
	assert(joueurActuel(JoueurActuel)),
	assert(tourActuel(TourActuel))
.


restaurerJoueurs([]):-!.
restaurerJoueurs([[A,B,C]|L]):-
	assert(joueursSav(A,B,C)),
	restaurerJoueurs(L).
restaurerBombes([]):-!.
restaurerBombes([[A,B]|L]):-
	assert(bombes(A,B)),
	restaurerBombes(L).
	
jouerMC(IdGagnant):- ((gameover, joueursSav(IdGagnant,_,-1)) ; tourActuel(50)), !. % Mettre
jouerMC(IdGagnant) :-
	joueurActuel(IdJoueur),
	joueursSav(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			(IdJoueur==0 ->
				iaJ1(Ia) ; iaGenerale(Ia)
			),
			ia(PosJoueur, NewPosJoueur, BombePosee, Ia),
			% Debug
			% afficherLesDetails(IdJoueur, NewPosJoueur, BombePosee),
			actualiserJoueur(IdJoueur,NewPosJoueur),
			(BombePosee==1 -> ajouterBombe(NewPosJoueur); true)

		)
	),
	decrementerBombes,
	exploserBombes,
	% Tuer des gens,

	joueurSuivant(IdJoueur,IdJoueurSuivant),

	retract(joueurActuel(_)),
	assert(joueurActuel(IdJoueurSuivant)),

	tourActuel(TA),
	retract(tourActuel(_)),
	TourSuivant is TA + 1,
	assert(tourActuel(TourSuivant)),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	jouerMC(IdGagnant),
	!
	.

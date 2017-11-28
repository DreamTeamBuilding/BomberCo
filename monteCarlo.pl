:- dynamic
	plateauSavMC/1,
	joueursSavMC/3,%joueursSav(Id, Positions, Etats)
	bombesMC/2,%bombes(Positions, TempsRestant)
	indexActionMC/3,%indexAction(CodeMouvement, Deplacement, PoserBombe)
	taillePlateauMC/1,
	nbJoueursMC/1,
	joueurActuelMC/1,
	tourActuelMC/1, %A supprimer
	finMC/1.
:-[ia].

actualiserJoueurMC(IdJoueur,NewPosJoueur):-
	retract(joueursSavMC(IdJoueur,_,StatusPrec)),assert(joueursSavMC(IdJoueur,NewPosJoueur,StatusPrec)).

ajouterBombeMC(Position):-
  nbJoueursMC(NbJoueurs),
  Duree is NbJoueurs*5,
  assert(bombesMC(Position, Duree)).

decrementerBombesMC:-
  findall(Temps,bombesMC(_, Temps), ListeTemps),
  findall(Pos,bombesMC(Pos,_),ListePos),
  decrementerListeMC(ListeTemps, ListeTempsDec, ListePos).

decrementerListeMC([],[],[]).
decrementerListeMC([X|Liste], [Y|ListeDec], [Pos|ListePos]):-
  Y is X-1,
  retract(bombesMC(Pos, _)),
  (Y>=0 -> assert(bombesMC(Pos, Y)) ; true),
decrementerListeMC(Liste, ListeDec, ListePos).


exploserBombesMC:-
	taillePlateauMC(TaillePlateau),
	% TODO : Oh c'est moche!!
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ-1), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ-2), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ+1), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ+2), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ-TaillePlateau), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ-2*TaillePlateau), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ+TaillePlateau), bombesMC(PositionB, 0), tuerMC(Id)) ; true),
	((joueursSavMC(Id, PositionJ, Status), PositionB is (PositionJ+2*TaillePlateau), bombesMC(PositionB, 0), tuerMC(Id)) ; true),!.

tuerMC(IdJoueur):-
	retract(joueursSavMC(IdJoueur, Position, _)),
	assert(joueursSavMC(IdJoueur, Position, 0)).

joueurSuivantMC(IdJoueur,IdJoueurSuivant):-
	nbJoueursMC(NbJoueurs),
	Id is IdJoueur + 1,
	IdJoueurSuivant is mod(Id,NbJoueurs).

gameoverMC:-not(plusieursEnVieMC).

plusieursEnVieMC:-joueursSavMC(X,_,-1),joueursSavMC(Y,_,-1),Y\==X.



jouerMC(IdGagnant):- (gameoverMC, joueursSavMC(IdGagnant,_,-1) ; tourActuelMC(50)), !, taillePlateauMC(TaillePlateau),retract(fin(0)),assert(fin(1)).
jouerMC(IdGagnant) :-
	joueurActuelMC(IdJoueur),

	joueursSavMC(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			plateauSavMC(Plateau),
			ia(Plateau, PosJoueur, NewPosJoueur, BombePosee, iav3),
			% Debug
			% afficherLesDetails(IdJoueur, NewPosJoueur, BombePosee),
			actualiserJoueurMC(IdJoueur,NewPosJoueur),
			(BombePosee==1 -> ajouterBombeMC(NewPosJoueur); true)

		)
	),
	decrementerBombesMC,
	exploserBombesMC,
	% Tuer des gens,

	joueurSuivantMC(IdJoueur,IdJoueurSuivant),

	retract(joueurActuelMC(_)),
	assert(joueurActuelMC(IdJoueurSuivant)),

	tourActuelMC(TA),
	retract(tourActuelMC(_)),
	TourSuivant is TA + 1,
	assert(tourActuelMC(TourSuivant)),

/** POUR L'IHM : DECOMMENTER/COMMENTER ICI **/
	jouerMC(IdGagnant),
	true %a delete (me permet de commenter plus simplement la ligne au dessus)
	.

jouerSimulationsPosition(_,_,CompteurVictoires, VictoiresTotales, 0) :- VictoiresTotales is CompteurVictoires.
jouerSimulationsPosition(IdJoueur, CompteurVictoires, VictoiresTotales, NewPosJoueur, NbSimulations) :-
	plateauSavMC = plateauSav,
	joueursSavMC = joueursSav,
	bombesMC = bombes,
	indexActionMC = indexAction,
	taillePlateauMC = taillePlateau,
	nbJoueursMC = nbJoueurs,
	joueurActuelMC = joueurActuel,
	tourActuelMC = tourActuel,
	finMC = fin,
	actualiserJoueurMC(IdJoueur,NewPosJoueur),
	jouerMC(IdGagnant),
	(IdGagnant is IdJoueur -> CompteurVictoires is CompteurVictoires + 1; true),
	NbSimulations is NbSimulations -1,
	jouerSimulationsPosition(IdJoueur, CompteurVictoires, VictoiresTotales, NewPosJoueur, NbSimulations).

jouerSimulationsBombe(_,_, CompteurVictoires, VictoiresTotales, 0) :- VictoiresTotales is CompteurVictoires.
jouerSimulationsBombe(IdJoueur, CompteurVictoires, VictoiresTotales, PosJoueur, NbSimulations) :-
	plateauSavMC = plateauSav,
	joueursSavMC = joueursSav,
	bombesMC = bombes,
	indexActionMC = indexAction,
	taillePlateauMC = taillePlateau,
	nbJoueursMC = nbJoueurs,
	joueurActuelMC = joueurActuel,
	tourActuelMC = tourActuel,
	finMC = fin,
	ajouterBombeMC(PosJoueur),
	jouerMC(IdGagnant),
	(IdGagnant is IdJoueur -> CompteurVictoires is CompteurVictoires + 1; true),
	NbSimulations is NbSimulations -1,
	jouerSimulationsBombe(IdJoueur, CompteurVictoires, VictoiresTotales, PosJoueur, NbSimulations).


testerMeilleurCoup([], PosActuelle, MeilleurPos, CompteurVictoire, BombePosee) :-
	joueurActuel(IdJoueur),
	jouerSimulationsBombe(IdJoueur, 0, NewCompteurVictoire, PosActuelle, 250),
	(NewCompteurVictoire > CompteurVictoire -> MeilleurPos is PosActuelle, BombePosee is 1; true).
testerMeilleurCoup([X|L], PosActuelle, MeilleurPos, CompteurVictoire, BombePosee) :-
	joueurActuel(IdJoueur),
	jouerSimulationsPosition(IdJoueur, 0, NewCompteurVictoire, X, 250),
	(NewCompteurVictoire > CompteurVictoire -> MeilleurPos is X, CompteurVictoire is NewCompteurVictoire; true),
	testerMeilleurCoup(L, PosActuelle, MeilleurPos, CompteurVictoire, BombePosee).


ia(Board, PosIndex, NewPosIndex, BombePosee, iavMC) :-
	posSuivantes(PosIndex, PositionsSuivantes),
	posSuivantesPossibles(Board, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	testerMeilleurCoup(PosSuivantesPossibles, PosIndex, NewPosIndex, 0, BombePosee).




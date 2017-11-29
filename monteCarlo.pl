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
			ia(Plateau, PosJoueur, NewPosJoueur, BombePosee, iav1),
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

jouerSimulationsPosition(_,_,CompteurVictoires, VictoiresTotales, 0) :-
	VictoiresTotales is CompteurVictoires.
jouerSimulationsPosition(IdJoueur, CompteurVictoires, VictoiresTotales, NewPosJoueur, NbSimulations) :-
		write("hello simu"),
	plateauSav(PlateauTEMP),
	assert(plateauSavMC(PlateauTEMP)),
	joueursSav(IdTEMP,_,_),
	joueursSav(IdTEMP,PositionsTEMP,EtatsTEMP),!,
	assert(joueursSavMC(IdTEMP,PositionsTEMP,EtatsTEMP)),
		write("2"),
	%bombes(PosTEMP,_),
	%bombes(PosTEMP,TempsTEMP),!,
	%assert(bombesMC(PosTEMP,TempsTEMP)),
		write("3"),
	indexAction(CodeTEMP,_,_),
	indexAction(CodeTEMP,DeplacementTEMP,PoserTEMP),!,
	assert(indexActionMC(CodeTEMP,DeplacementTEMP,PoserTEMP)),
	taillePlateau(TailleTEMP),
	assert(taillePlateauMC(TailleTEMP)),
	nbJoueurs(NbTEMP),
	assert(nbJoueursMC(NbTEMP)),
	joueurActuel(JoueurTEMP),
	assert(joueurActuelMC(JoueurTEMP)),
	tourActuel(TourTEMP),
	assert(tourActuelMC(TourTEMP)),
	fin(FinTEMP),
	assert(finMC(FinTEMP)),

	actualiserJoueurMC(IdJoueur,NewPosJoueur),!,
	write("hello simu 3"),

	jouerMC(IdGagnant),
	write("hello simu 4"),

	(IdGagnant is IdJoueur -> CompteurVictoires is CompteurVictoires + 1; true),
	NbSimulations is NbSimulations -1,

	write("hello simu 5"),

	jouerSimulationsPosition(IdJoueur, CompteurVictoires, VictoiresTotales, NewPosJoueur, NbSimulations),
	write("hello simu 6")

	.

jouerSimulationsBombe(_, CompteurVictoires, VictoiresTotales, _, 0) :- VictoiresTotales is CompteurVictoires.
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
	write("hello test"),
	jouerSimulationsPosition(IdJoueur, 0, NewCompteurVictoire, X, 250),
	write(IdJoueur), write(" "), write(NewCompteurVictoire),
	(NewCompteurVictoire > CompteurVictoire -> MeilleurPos is X, CompteurVictoire is NewCompteurVictoire; true),
	testerMeilleurCoup(L, PosActuelle, MeilleurPos, CompteurVictoire, BombePosee).


iaMC(Board, PosIndex, NewPosIndex, BombePosee, iaMC) :-
	write("hello"),
	posSuivantes(PosIndex, PositionsSuivantes),
	posSuivantesPossibles(Board, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	write(PosSuivantesPossibles),
	testerMeilleurCoup(PosSuivantesPossibles, PosIndex, NewPosIndex, 0, BombePosee).




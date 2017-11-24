:- Dynamic
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

jouerMC:- (gameover;tourActuel(50)), !, taillePlateauMC(TaillePlateau), displayBoard(TaillePlateau), writeln('Game is Over.'),retract(fin(0)),assert(fin(1)).
jouerMC :-
	joueurActuelMC(IdJoueur),

	joueursSavMC(IdJoueur,PosJoueur,StatusJoueur),
	(StatusJoueur==0 -> true ;
		(
			plateauSavMC(Plateau),
			ia(Plateau, PosJoueur, NewPosJoueur, BombePosee, iav4),
			% Debug
			% afficherLesDetails(IdJoueur, NewPosJoueur, BombePosee),
			actualiserJoueurMC(IdJoueur,NewPosJoueur),
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
	jouer,
	true %a delete (me permet de commenter plus simplement la ligne au dessus)
	.

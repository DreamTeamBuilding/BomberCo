:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(bomberCo).

:- multifile http:location/3.
:- dynamic   http:location/3.
http:location(files, "/files", []).

:- http_handler(files(.), http_reply_from_files("assets", []), [prefix]).

:- http_handler(root(.), accueil, []).
:- http_handler(root(game), getInfoGame, []).
:- http_handler(root(starting), starting, []).
:- http_handler(root(playMove), playMove, []).
:- http_handler(root(playMoveJoueur), playMoveJoueur, []).

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port,[]).

accueil(_) :-
		reply_html_page(
	   [title("BomberCo"),
	   link([rel="icon", type="img/ico",href="files/favicon.ico"]),
	   link([rel="stylesheet", type="text/css", href="files/theme.css"])],
	   [h1("Just look"),
	   div(id="conteneur","Partie non demarree"),
	   div(id="conteneur2",""),
	   script(src="files/jquery.js",""),
	   script(src="files/ihm_action.js","")]).
	
starting(Request) :-
	http_parameters(Request, [
		players(PlayersData,[]),
		size(SizeData,[]),
		iaPlayer1(IaPlayer1Data, []),
		iaPlayer2(IaPlayer2Data, [])
		]),
	atom_number(PlayersData, Players),
	atom_number(SizeData, Size),
	atom_number(IaPlayer1Data, IaPlayer1),
	atom_number(IaPlayer2Data, IaPlayer2),
	lancerPartie(Players, Size, IaPlayer1, IaPlayer2),
	reply_json_dict("{\"result\":1}").

playMove(_) :-
	(
		fin(0)
	->
		(jouer,reply_json_dict("{\"result\":1}"))
	;
		reply_json_dict("{\"result\":0}")
	)
	.

playMoveJoueur(Request) :-
	http_parameters(Request, [
		action(ActionData,[])
		]),
	atom_number(ActionData, Action),
	(
		fin(0)
	->
		(jouerVraiJoueur(Action),reply_json_dict("{\"result\":1}"))
	;
		reply_json_dict("{\"result\":0}")
	)
	.

getInfoGame(_):-
	taillePlateau(TP),
	nbJoueurs(NBJ),
	fin(Fin),
	tourActuel(TourActuel),
	findall([Y,X],joueursSav(Y,X,-1),JoueursVivants),
	findall([Y,X],joueursSav(Y,X,0),JoueursMorts),
	findall([X,Y],bombes(X,Y),Bombes),
	plateauSav(Plateau),
	getStringFromDoubleList(JoueursVivants,StrVivants),
	getStringFromDoubleList(JoueursMorts,StrMorts),
	getStringFromDoubleList(Bombes,StrBombes),
	getStringFromList(Plateau,StrPlateau),
	StringTab = [
	"{",
	"\"taillePlateau\":",TP,
	",\"nbJoueurs\":",NBJ,
	",\"plateau\" : [",StrPlateau,"]",
	",\"joueursVivants\" : [",StrVivants,"]",
	",\"joueursMorts\" : [",StrMorts,"]",
	",\"bombes\" : [",StrBombes,"]",
	",\"fin\":",Fin,
	",\"tourActuel\":",TourActuel,
	"}"],
	getStringFromConcat(StringTab, S),
	reply_json_dict(S)
	.

	
getStringFromConcat([],""):-!.
getStringFromConcat([X|Liste], String):-getStringFromConcat(Liste,StringPrec),atom_concat(X,StringPrec,String).

getStringFromList([],""):-!.
getStringFromList([X],S):-atom_concat(X,"",S).
getStringFromList([X|Liste],String):-getStringFromList(Liste,StringPrec),atom_concat(X,",",Virgule),atom_concat(Virgule,StringPrec,String).

getStringFromDoubleList([],""):-!.
getStringFromDoubleList([X],S):-getStringFromList(X,StringX),getStringFromConcat(["[",StringX,"]"],S).
getStringFromDoubleList([X|Liste],String):-getStringFromList(X,StringX),getStringFromDoubleList(Liste,StringPrec),getStringFromConcat(["[",StringX,"]",",",StringPrec], String).
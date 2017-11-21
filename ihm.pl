:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_json)).

:- multifile http:location/3.
:- dynamic   http:location/3.
http:location(files, '/files', []).

:- http_handler(files(.), http_reply_from_files('assets', []), [prefix]).

:- http_handler(root(.), accueil, []).
:- http_handler(root(game), getInfoGame, []).

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port,[]).

accueil(_) :-
		reply_html_page(
	   [title('BomberCo')],
	   [h1('Just look'),
	   div(id='div','Plateau'),
	   script(src='files/jquery.js',''),
	   script(src='files/ihm_action.js','')]).
	

getInfoGame(_):-
	taillePlateau(TP),
	nbJoueurs(NBJ),
	StringTab = ['{[taillePlateau:',TP,',nbJoueurs:',NBJ,']}'],
	getString(StringTab, S),
	reply_json_dict(S).

	
getString([],''):-!.
getString([X|Liste], String):-getString(Liste,StringPrec),atom_concat(X,StringPrec,String).
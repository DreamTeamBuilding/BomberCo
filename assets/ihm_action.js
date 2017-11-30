var interval ;
var playerTurn = 1;
var realPlayer = false;
var numberOfPlayer = 2;
var offset;

 $(document).ready(function(){
	 $('#conteneur2').html("<br/><input type='button' onclick='start()' value='Start the game'/>");
});

 function boucle(){
	 alert('Début de partie !');
	 //Clear l'intervalle précédent
	 clearInterval(interval);
	 //Plus court pour real player pour eviter impression de non reactivite aux commandes
	 if(realPlayer)
	 	interval = setInterval(function(){ play();}, 50);
	 else
	 	interval = setInterval(function(){ play();}, 300);
 }

 function start(){
  offset = Math.floor(Math.random() * 6);
	$("h1").text("Boom boom boom boom");
	numberOfPlayer = prompt("Nombre de joueur :", "2,3,4")[0];
	console.log(numberOfPlayer);
	var boardSize = prompt("Taille plateau :", "11");
	console.log(boardSize);
	var iaPlayer1 = prompt("Choisir ia joueur 1\nSeule l'ia joueur 1 peut être un vrai joueur :", "0,1,2,3,4,5")[0];
	console.log(iaPlayer1);
	var iaPlayer2 = prompt("Choisir ia autre(s) joueur(s) :", "1,2,3,4,5")[0];
	console.log(iaPlayer2);

	$.ajax({
				dataType: 'json',
				url:'/starting',
				data: {
					'players': numberOfPlayer,
					'size': boardSize,
					'iaPlayer1': iaPlayer1,
					'iaPlayer2': iaPlayer2
					 },
				contentType: 'application/json; charset=utf-8',
				success: function (result) {
					console.log(result);
				}
	 });
	if (iaPlayer1 == 0){
		realPlayer = true;
		$(document).keydown(handlePress);
	}
	boucle();
 }

function handlePress(e){
	var action = 5;
	switch(e.which)
	{
		case 90:
		case 122:
			console.log("haut");
			action = 1;
			break;
		case 83:
		case 115:
			console.log("bas");
			action = 2;
			break;
		case 81:
		case 113:
			console.log("gauche");
			action = 4;
			break;
		case 68:
		case 100:
			console.log("droite");
			action = 3;
			break;
		case 16:
			console.log("bombe");
			action = 6;
			break;
		case 32:
			console.log("immobile");
			action = 5;
			break;
		default:
			console.log("autre");
			action = 5;
			break;
	}
	if (realPlayer && playerTurn%numberOfPlayer == 1) {
		requestData();
		computeDataRealPlayer(action);
		playerTurn++;
	}
}

 function fin(){
	 clearInterval(interval);
	 interval = null;
	 realPlayer = false;
	 playerTurn = 1;
	 $("h1").text("Game over");
 }

 function play() {
 	requestData();
 	if(!(realPlayer && playerTurn%numberOfPlayer==1))
 	{
		computeData();
		playerTurn++;
	}
}

function computeDataRealPlayer(action){
	$.ajax({
						dataType: 'json',
						url:'/playMoveJoueur',
						data: {
							'action': action
						},
						contentType: 'application/json; charset=utf-8',
						success: function (result) {
							console.log(result);
						}
			 });
}

function computeData(){
	$.ajax({
					dataType: 'json',
					url:'/playMove',
					contentType: 'application/json; charset=utf-8',
					success: function (result) {
						console.log(result);
					}
		 });
}

 function requestData(){
	$.ajax({
				dataType: 'json',
				url:'/game',
				contentType: 'application/json; charset=utf-8',
				success: function (game) {
					console.log(game);
					writeHtml(buildString(game));
				}
	 });
 }

 function writeHtml(code){
	 $('#conteneur').html(code);
 }


 function buildString(infoGame){
	 var jsonVar = JSON.parse(infoGame);
	 if(jsonVar.fin==1){
		 fin();
		 return;
	 }
	 var taille = jsonVar.taillePlateau;

	 var individualSize = 500/taille;

	 var string = "";

   // Sol
   $('#conteneur').css( 'background', 'url(files/ground.png)' );
   $('#conteneur').css( 'background-size', individualSize);

	 // Bombe
	 for(pos in jsonVar.bombes){
		var index = jsonVar.bombes[pos][0];
		var temps = jsonVar.bombes[pos][1];
		var x = getX(index, taille);
		var y = getY(index, taille);
		if(temps>0){
			string += "<img src='files/bomb.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
				"'/>";
		}else{
			var xEplo = x;
			var yExplo = y;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
		}
	 }
	 // Joueurs vivants
	 for(pos in jsonVar.joueursVivants){
		var id = jsonVar.joueursVivants[pos][0];
		var index = jsonVar.joueursVivants[pos][1];
		var x = getX(index, taille);
		var y = getY(index, taille);
		string += "<img src='files/perso"+(id+offset)%6+".png' class='joueurEnVie'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
	 }
	 // Joueurs morts
	 for(pos in jsonVar.joueursMorts){
		var id = jsonVar.joueursMorts[pos][0];
		//Si le joueur reel est mort alors on dit qu'il n'y a plus de joueur reel
		if(realPlayer && id == 0)
			realPlayer = false;
		var index = jsonVar.joueursMorts[pos][1];
		var x = getX(index, taille);
		var y = getY(index, taille);
		string += "<img src='files/dead.png' class='joueurMort'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
	 }

	 // Murs
	 for(index in jsonVar.plateau){
		if(jsonVar.plateau[index]){
		var x = getX(index, taille);
		var y = getY(index, taille);
		string += "<img src='files/wall.png' class='mur'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
		}
	 }
	 return string;
 }

 function getX(index, taillePlateau){
	 return index%taillePlateau;
 }
 function getY(index, taillePlateau){
	 return (index-(index%taillePlateau))/taillePlateau;
 }

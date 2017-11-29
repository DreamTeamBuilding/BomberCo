var interval ;
 
 $(document).ready(function(){
	 $('#conteneur2').html("<br/><input type='button' onclick='start()' value='Start the game'/>");
});

 function boucle(){
	 alert('Début de partie !');
	 interval = setInterval(function(){ requestData(); computeData() ;}, 300);
 }
 
 function start(){
 	var numberOfPlayer = 2;
 	var boardSize = 11;
	$.ajax({
				dataType: 'json', 
				url:'http://localhost:8000/starting',
				data: {
					'players': numberOfPlayer, 
					'size': boardSize },
				contentType: 'application/json; charset=utf-8',
				success: function (result) {
					console.log(result);    
				}
	 });
	 boucle();
 }
 
 function fin(){
	 clearInterval(interval);
 }
 
 function computeData() {
	$.ajax({
				dataType: 'json', 
				url:'http://localhost:8000/playMove',
				contentType: 'application/json; charset=utf-8',
				success: function (result) {
					console.log(result);    
				}
	 });
}
 
 function requestData(){
	$.ajax({
				dataType: 'json', 
				url:'http://localhost:8000/game',
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
			var xEplo = x-2;
			var yExplo = y;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x-1;
			yExplo = y;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x;
			yExplo = y;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x+1;
			yExplo = y;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x+2;
			yExplo = y;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x;
			yExplo = y-2;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x;
			yExplo = y-1;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x;
			yExplo = y+1;
			string += "<img src='files/boom.png' class='bombe'"+
				"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
				"top:"+(yExplo*individualSize)+"px; left:"+(xEplo*individualSize)+"px"+
				"'/>";
			xEplo = x;
			yExplo = y+2;
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
		string += "<img src='files/perso"+id+".png' class='joueurEnVie'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
	 }
	 // Joueurs morts
	 for(pos in jsonVar.joueursMorts){
		var id = jsonVar.joueursMorts[pos][0];
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
		string += "<div class='mur'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'></div>";
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
 
 
var interval ;
 
 $(document).ready(function(){
	 $('#conteneur2').html("<br/><input type='button' onclick='start()' value='Start the game'/>");
 });
 
 function boucle(){
	 alert('Début de partie !');
	 interval = setInterval(function(){ requestData(); computeData() ;}, 100);
 }
 
 function start(){
	$.ajax({
				dataType: 'json', 
				url:'http://localhost:8000/starting',
				contentType: 'application/json; charset=utf-8',
				success: function (result) {
					console.log(result);    
				}
	 });
	 boucle()
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
	 // Murs 
	 for(index in jsonVar.plateau){
		if(jsonVar.plateau[index]){
		x = getX(index, taille);
		y = getY(index, taille);
		string += "<div class='mur'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'></div>";
		}
	 }
	 // Bombe
	 for(pos in jsonVar.bombes){
		index = jsonVar.bombes[pos];
		x = getX(index, taille);
		y = getY(index, taille);
		string += "<img src='files/bomb.png' class='bombe'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
	 }
	 // Joueurs vivants
	 for(pos in jsonVar.joueursVivants){
		id = jsonVar.joueursVivants[pos][0];
		index = jsonVar.joueursVivants[pos][1];
		x = getX(index, taille);
		y = getY(index, taille);
		string += "<img src='files/perso"+id+".png' class='joueurEnVie'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
	 }
	 // Joueurs morts
	 for(pos in jsonVar.joueursMorts){
		id = jsonVar.joueursMorts[pos][0];
		index = jsonVar.joueursMorts[pos][1];
		x = getX(index, taille);
		y = getY(index, taille);
		string += "<img src='files/dead.png' class='joueurMort'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'/>";
	 }
	 
	 return string;
 }
 
 function getX(index, taillePlateau){
	 return index%taillePlateau;
 }
 function getY(index, taillePlateau){
	 return (index-(index%taillePlateau))/taillePlateau;
 }
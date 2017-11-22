$( document ).ready(requestData());
 
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
		string += "<div class='bombe'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'></div>";
	 }
	 // Joueurs vivants
	 for(pos in jsonVar.joueursVivants){
		index = jsonVar.joueursVivants[pos];
		x = getX(index, taille);
		y = getY(index, taille);
		string += "<div class='joueurEnVie'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'></div>";
	 }
	 // Joueurs morts
	 for(pos in jsonVar.joueursMorts){
		index = jsonVar.joueursMorts[pos];
		x = getX(index, taille);
		y = getY(index, taille);
		string += "<div class='joueurMort'"+
			"style='width:"+individualSize+"px;height:"+individualSize+"px;"+
			"top:"+(y*individualSize)+"px; left:"+(x*individualSize)+"px"+
			"'></div>";
	 }
	 
	 return string;
 }
 
 function getX(index, taillePlateau){
	 return index%taillePlateau;
 }
 function getY(index, taillePlateau){
	 return (index-(index%taillePlateau))/taillePlateau;
 }
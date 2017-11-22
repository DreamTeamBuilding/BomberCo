$( document ).ready(function(){
	$.ajax({
				dataType: 'json', 
				url:'http://localhost:8000/game',
				contentType: 'application/json; charset=utf-8',
				success: function (game) {
					console.log(game);                
				}
	 });
 });
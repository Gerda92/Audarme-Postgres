(function(){

	var plugin = {
		/**
		* Adding to choosed element functionality
		*/
		appendTo : function(element, action){
			if((typeof element === "object" || typeof element === "array" ) && element.length > 0){
				var SELF = plugin;
				element.on(action, function(event){
					if(window.getSelection){
						var text = window.getSelection().toString();
						var result = SELF.query( text );
					} else console.log( "The browser don't support the api" );
				});
			} else console.log( "Function need jQuery object" );
		},
		/**
		* Query to server api
		*/
		query : function(text){
			//self
			var API = this;
			//end
			var url = "http://audarme.kz/words/ru/";
			var text = $.trim( text ) || "абадан";
			var result = "";
			url += text;
			$.ajax({
				url : url,
				type : "GET",
				dataType: "JSON",
				beforeSend : function(){
					var connect = "Переводим - " + text;
					API.showTooltip(connect, "alert");
				},
				success : function(data){
					result = "Перевод <br>" + data.definition;
					API.showTooltip(result, "success");
				},
				error : function(errCode){
					console.log( errCode.fail() )
					API.showTooltip("При переводе возникла ошибка", "error");
				}
			});
			return result;
		},
		/**
		* Show helpes to see result (popover)
		*/
		showTooltip : function(text, type){
			var time = 20000;
			var n = noty({
				text : text,
				type : type,
				layout : "bottomRight"
			});
			setTimeout(function(){
				var _id_ = n.options.id;
				$.noty.close( _id_ ); 
			}, time);
		}
	}

	//set to global
	window.AUDARME = {
		translate : plugin.appendTo
	}

}());

// $("document").ready(function(){

// 	plugin.appendTo($("p"), "dblclick select");

// });
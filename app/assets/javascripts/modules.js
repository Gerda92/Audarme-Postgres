var modules = {}
var global = {
	lan : ["ru", "kz"],
	current : 1
}

/**
* Module initializing
*/

modules.collect = (function(){
	var Idata = [];
	var Iheap = [];
	Idata.push("collect");
	for(var i in modules){
		var st = false;
		for(var j = 0; j < Idata.length; j++)
			if(Idata[j] == i){
				st = true;
				break;
			}
		if(!st)
			Iheap.push(modules[i]);
	}
	for(var i = 0; i < Iheap.length; i++){
		Iheap[i].call();
		console.log("Start work --> function " + (i+1));
	}
});

/**
* Starting modules
*/

modules["language-change"] = (function(){
		
	var _init = function(){
		var btn = $("#js-swap-lan");
		btn.bind("click", function(){
			btn.html(global.current == 1? 'ru→kz' : 'kz→ru');
			global.current = (global.current + 1) % global.lan.length;

		});
	}
	_init.call();
});

modules["suggestions"] = (function(){

	var _init = function(){

		var input = $("#js-text-search");
		input.bind("keyup", function()
		{
			var val = $(this).val();
			var query = val.toString();
			var those = $(this);

			$.ajax({
				url : "words/suggest/" + global.lan[global.current] + "/" + query,
				success: function (data) {
					var source = [];
					for(var i = 0; i < data.length; i++){
						source.push(data[i].name);
					}
					load( source , those);					
				},
				beforeSend : function(){
					var id = "template-id-1231oi45";
					$(id).remove();
				}
			});
		});
 
		var load = (function(source, object)
		{	
			load_placeholder( source.length, object.val().length );
			if(source.length > 0){

				object.autocomplete({
					source : source
				});

			}else{ console.log("The length of source if 0"); }
		});

		var load_placeholder = (function(sourceLen, inputLen)
		{
			var message = "";
			if(inputLen < 2)
				message += "Длина запроса должна быть больше 1. ";
			if(!sourceLen)
				message += "На ваш запрос ничего не найдено!"
			var id = "template-id-1231oi45";
			var template = "<div id=" + id + "><h5>" + message + "</h5></div>"
			if(!sourceLen || inputLen < 2)
				$("#js-word-title").html( template );
			else if(sourceLen) 
				$("#" + id).remove();
		});
	}

	var load_suggest = function(query){
		var url = "words/suggest/" + global.lan[global.current] + "/" + query;
		return jQuery.parseJSON(
			$.ajax({url : url, async: false}).responseText
		);
	}

	_init.call();
});

modules["load-word"] = (function(){

	var _data_ = {
		getButton : $("#js-button-search"),
		getInput  : $("#js-text-search")
	}

	var _init = function(){

		_data_.getButton.bind("click", function(){
			action();
			//load_nearby();
		});

		_data_.getInput.bind("keydown", function(ev){
			if(ev.keyCode == 13){
				//pressed enter
				//action();
			}
		});
	}

	var action = function(){
		var vl = _data_.getInput.val();
		console.log ( vl )
		var url = "words/" + global.lan[global.current] + "/" + vl;
		$.ajax({
			url : url,
			type : "GET",
			dataType: "JSON",
			success : function(_json_){
				var object = _json_ || {};
				var title = $("#js-word-title");
				var content = $("#js-word-content");
				title.html(vl);
				content.html(object.definition);
			},
			error : function(){
				var content = $("#js-word-content");
				content.html("Ваше слово не найдено!");
			}
		});
	}

	var load_nearby = function(){
		var vl = _data_.getInput.val();
		var url = "words/nearby/" + global.lan[global.current] + "/" + vl;
		$.ajax({
			url : url,
			type : "GET",
			dataType: "JSON",
			success : function(data){
				var ul = $("#js-nearby-words"); ul.html("");
				for(var i = 0; i < data.length; i++){
					var li = $('<li><a href="">' + data[i].name + "</a></li>")
						.appendTo(ul);
				if (data[i].name == vl)
					li.attr('class', 'active');
				}		
			},
			error : function(){
				$("#js-word-title").html("");
			}
		});		
	}

	//the queue of actions
	_init.call();
});
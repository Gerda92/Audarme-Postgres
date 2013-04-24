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
		$('#js-text-search').typeahead({
			source: function (typeahead, query) {
				$.ajax({
					url : "words/suggest/" + global.lan[global.current] + "/" + query,
					async: false,
					success: function (data) {
						var source = [];
						for(var i = 0; i < data.length; i++){
							source.push(data[i].name);
						}
				    	typeahead.process(source);					
					}
				});

		    },
			matcher: function (item) { return true; }
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
		});

		_data_.getInput.bind("keydown", function(ev){
			if(ev.keyCode == 13){
				//pressed enter
				action();
			}
		});
	}

	var action = function(){
		var vl = _data_.getInput.val();
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
				//document.location.replace(url);
			},
			error : function(){
				var content = $("#js-word-content");
				content.html("Ваше слово не найдено!");
			}
		});
	}

	//the queue of actions
	_init.call();
});
var modules = {}
var sandbox = {}
var global = {
	lan : ["ru", "kz"],
	current : 0
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
modules["modal-bg-module"] = (function(){
	var self = window;
	var sandbox = self.sandbox;
	var _modal_controller = {
		time: 0,
		modal_bg : function(){
			var those = $(".modal-back");
			return those;
		},
		open : function(){
			var md = this.modal_bg();
			md.fadeIn(this.time);
		},	
		close : function(){
			var md = this.modal_bg();
			md.fadeOut(this.time);
		},
		setTimeout: function(time){
			this.time = time;
		}
	}
	sandbox["modalBack"] = _modal_controller;
});
modules["modal-module"] = (function(){
	var api = {
		modalBackOpen: function(){
			window.sandbox.modalBack.open();
		},
		modalBackClose: function(){
			window.sandbox.modalBack.close();
		},
		setModalBackTimeout: function(time){
			var time = time || 0;
			window.sandbox.modalBack.setTimeout(time);
		},
		open: function(id){
			var modal = $("#" + id);
			modal.show();
			this.modalBackOpen();
			this.addCloseButtonAction(modal);
		},
		close: function(id){
			var modal = $("#" + id);
			modal.fadeOut(300);
			this.setModalBackTimeout(500);
			this.modalBackClose();
		}, 
		addCloseButtonAction: function(modal){
			var self = this;
			modal.find(".close-button").bind("click", function(){
				self.close(modal.attr("id"));
			});
			$(window).bind("keydown.CLOSE_ACTION", function(ev){
				if(ev.keyCode == 27){
					self.close(modal.attr("id"));
					$(window).unbind("keydown.CLOSE_ACTION");
				}
			});
		}
	}
	var _contstructor_ = (function(){
		var open = $(".modal-open");
		open.bind("click", function(){
			var dataId = $(this).attr("data-modal");
			if(dataId){
				api.open(dataId);
			}else{
				console.log("Cannot find data-modal attribute on modal caller");
			}
		});
	});
	_contstructor_(); 
});
modules["language-change"] = (function(){
		
	var _init_ = function(){
		var btn = $("#js-swap-lan");
		btn.bind("click", function(){
			var s = $("#js-swap-1").html();
			var b = $("#js-swap-2").html();
			$("#js-swap-1").html(b);
			$("#js-swap-2").html(s);
			
			global.current = (global.current + 1) % global.lan.length;

		});
	}
	_init_.call();
});


modules["enter-button"] = (function(){
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
			else{
				//32 27 8 9
				var list_none = [32, 27, 9, 18];
				var st = true;
				for(var i = 0; i < list_none.length; i++){
					if(ev.keyCode == list_none[i]){
						st = false;
						break;
					}
				}
				if(st){
					//continue and wait 200 secunds
					setTimeout(load_suggest, 200);
				}
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
				alert("Ваше слово не найдено!");
			}
		});
	}
	var load_suggest = function(){
		var vl = _data_.getInput.val();
		var url = "words/suggest/" + global.lan[global.current] + "/" + vl;
		//loading some ajax
		$.ajax({
			url : url,
			success : function(_json_){
				loadResult(_json_);	
			}
		});
	}

	var loadResult = function(ob){
		var object = ob || {};
		var input = _data_.getInput;
		//iterate all objects
		var html = [];
		var len = object.length;
		for(var i = 0; i < len; i++){
			html.push(object[i].name);
		}
		input.autocomplete({
	      source: html
	    });
	}
	//the queue of actions
	_init.call();
});
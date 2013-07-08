#saving modules
_modules = []

#order to start
_queue = []

#def of class
class Module
	constructor: (config) ->
		if config.name && config.init
			@config = config
			if config.autoload
				@init();
		else console.log "Need more params"
	init: ->
		@startPrint()
		_queue.push @config.init
	startPrint: ->
		console.log "Module '#{@config.name}' -> start at #{Date.now()}"
	setApi: ->
		cf = @config
		_queue.push ->
			if cf.api
				global_name = cf.api.name
				window[global_name] = cf.api.fn
			else	console.log "Need more params"

#define buttons and other
container = new Module {
	name : "Site entities module"
	autoload: false
	init: ->
	api: {
		name : "SITE_ENT"
		fn: {
			get_search_button : ->
				$("#js-search-btn")
			get_search_input  : ->
				$("#js-search-inp")
			get_text_container : ->
				$("#js-text-container")
			get_language_container : ->
				$("#js-language-select")
			get_keyboard_container : ->
				$("#js-keyboard")
			get_keyboard_tumblr : ->
				$("#js-enable-keyboard")
			get_autocomplete_tumblr : ->
				$("#js-enable-autocomplete")
			get_spinner : ->
				$(".js-loading")
		}
	}
}
container.setApi()

#set to global namespace
window.Module = Module

#start after loading document
$(document).ready ->
	for i in _queue
		i()
query = (val)->
	#blank?
	return false if val.length == 0

	#start search
	language = window.CURRENT_LANGUAGE
	val = val.toLowerCase()
	$.ajax {
		url : "http://audarme.kz/words/#{language}/#{val}"
		success : (data)->
			complete JSON.parse(data)
		error : (data)->
			console.log data
		beforeSend : ->
			console.log "Translate with query #{val}"
	}

#when query success and done
complete = (data) ->
	SITE_ENT.get_text_container().html(
		"<p class=text-inf >#{data.definition}</p>"
	)


autocomplete = (val) ->
	#blank?
	return false if val.length == 0

	#set background scene
	SITE_ENT.get_text_container().hide()
	SITE_ENT.get_spinner().show()

	#search autocomplete
	language = window.CURRENT_LANGUAGE
	$.ajax {
		word : val
		url : "http://audarme.kz/words/suggest/#{language}/#{val}"
		success : (data)->
			if window.CURRENT_WORD is @word
				autocomplete_l data
			else if window.CURRENT_WORD.length is 0
				SITE_ENT.get_text_container().html('<h6>Введите что-нибудь в строку поиска!</h6>').show()
				SITE_ENT.get_spinner().hide()
	}

autocomplete_l = (data)->
	list = ""
	if data.length > 0
		data.forEach (a, index) ->
			list += "<p class=js-suggest><span>#{index+1}. </span><span class='text'>#{a.name}</span></p>"
	else
		list += "<h6>К сожалению по вашему запросу ничего не найдено!<h6>"
	container = SITE_ENT.get_text_container().html(list)

	$(".js-suggest").on 'click', ->
		value = $(this).children('.text').html().toLowerCase()
		SITE_ENT.get_search_input().val( value ).focus()

	SITE_ENT.get_spinner().hide()
	SITE_ENT.get_text_container().show()



new Module {
	name : "Query module"
	autoload : true
	init : ->
		window.CURRENT_WORD = ""
		SITE_ENT.get_search_button().on 'click', ->
			inp = SITE_ENT.get_search_input()
			query inp.val() 
		SITE_ENT.get_search_input().on 'keyup', (ev)->
			key = ev.keyCode || 187
			#global
			window.CURRENT_WORD = $(this).val()
			#search word
			if(key == 13)
				query $(this).val()

			#search autocomplete
			else if window.AUTOCOMPLETE_STATUS
				len = $(this).val().length
				testing = $(this).val().substring( len - 1, len)
				if ((key >= 48 and key <= 90) or (key is 187)) and (not /[a-z|A-Z]/.test( testing )) or (key is 8)
					text = $(this).val().toLowerCase() 
					autocomplete(text) if text.length > 0 
}

new Module {
	name : "Language settings module"
	autoload : true
	init : ->
		window.CURRENT_LANGUAGE = ''
		#set default value
		SITE_ENT.get_language_container().find("input").each ->
			window.CURRENT_LANGUAGE = $(this).val() if $(this).attr("checked")
		#update on click
		SITE_ENT.get_language_container().find("input").on 'click', ->
			window.CURRENT_LANGUAGE = $(this).val()
}

new Module {
	name : "Fill keyboard module"
	autoload: true
	init : ->
		container = SITE_ENT.get_keyboard_container().children('.content')
		alphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ ІӘҢҒҮҰҚӨҺ"
		for i in [0..alphabet.length-1]
			container.append("<a href='' class='k-btn js-key-btn'>#{alphabet[i]}</a>")
		container.append("<a href='' class='k-btn js-key-btn-remove'>←</a>")
}

new Module {
	name : "On/off keyboard module"
	autoload: true
	init : ->
		container = SITE_ENT.get_keyboard_container()
		btn = SITE_ENT.get_keyboard_tumblr()
		btn.on 'click', ->
			if container.attr('data-display') == 'off'
				container.fadeOut('fast').attr('data-display', 'on')
			else
				container.fadeIn('fast').attr('data-display', 'off')	
}

new Module {
	name : "Action of press btn"
	autoload : true
	init : ->
		#buttons
		$(".js-key-btn").click ->
			value = $(this).text().toLowerCase()
			inp = SITE_ENT.get_search_input()
			inp.val( inp.val() + value )
			inp.trigger('keyup')
			return false
		#backspace
		$(".js-key-btn-remove").click ->
			inp = SITE_ENT.get_search_input()
			value = inp.val()
			inp.val( value.substring(0, value.length-1) )
			inp.trigger('keyup');
			return false
}

new Module {
	name : "Autocomplete-enable module"
	autoload : true
	init : ->
		#default settings
		if SITE_ENT.get_autocomplete_tumblr().attr('checked') == 'checked'
			window.AUTOCOMPLETE_STATUS = true
			SITE_ENT.get_autocomplete_tumblr().attr('checked')

		#checking
		SITE_ENT.get_autocomplete_tumblr().click ->
			if $(this).attr('checked') is 'checked'
				window.AUTOCOMPLETE_STATUS = false
				$(this).removeAttr('checked')
			else
				window.AUTOCOMPLETE_STATUS = true
				$(this).attr('checked', 'checked')
}
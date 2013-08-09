random_h = 0
changeLanguage = ->
	SITE_ENT.get_language_container().find("input")[++random_h%2].click()

#loading placeholder
showLoading = ->
	SITE_ENT.get_spinner().show()
	SITE_ENT.get_text_container().hide()

#showing content
showContent = ->
	SITE_ENT.get_spinner().hide()
	SITE_ENT.get_text_container().show()

query = (val)->
	console.log val
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
			showContent()
			SITE_ENT.get_text_container().html(
				"<h5 class='well bold'>К сожалению по вашему запросу ничего не найдено!</h5>"
			)
		beforeSend : ->
			console.log "Translate with query '#{val}'"
			showLoading()
	}

#when query success and done
complete = (data) ->
	showContent()
	SITE_ENT.get_text_container().html(
		"<p class=text-inf >#{data.definition}</p>"
	)
	SITE_ENT.get_text_container().find('a').on 'click', ->
		vl = $(this).text()
		#change language of app
		changeLanguage()
		SITE_ENT.get_search_input().val( vl ).focus()
		SITE_ENT.get_search_button().click()
		return false


autocomplete = (val) ->
	#blank?
	return false if val.length == 0

	val = val.toLowerCase()

	#set background scene
	showLoading()

	#search autocomplete
	language = window.CURRENT_LANGUAGE
	$.ajax {
		word : val
		url : "http://audarme.kz/words/suggest/#{language}/#{val}"
		success : (data)->
			if window.CURRENT_WORD.toLowerCase() is @word
				autocomplete_l data
			else if window.CURRENT_WORD.length is 0
				SITE_ENT.get_text_container().html("<h5 class='well bold'>Введите что-нибудь в строку поиска!</h5>").show()
				SITE_ENT.get_spinner().hide()
		error : (data)->
			SITE_ENT.get_text_container().html(
				"<h5 class='well bold'>Что-то пошло не так! Попробуйте снова.</h5>"
			)

	}

autocomplete_l = (data)->
	setValue = (vl)->
		SITE_ENT.get_search_input().val( vl ).focus()

	# console.log data
	list = ""
	if data.length > 0
		data.forEach (a, index) ->
			definition = "<span class='short-title'>#{a.definition.substring(0, 80)}</span>"
			list += "<p class=js-suggest><span class='text'>#{a.name}</span><span class='icon-arrow-right js-suggest-icon'></span></p>"
	else
		list += "<h5 class='well bold'>К сожалению по вашему запросу ничего не найдено!<h5"
	container = SITE_ENT.get_text_container().html(list)

	$(".js-suggest").on 'click', ->
		value = $(this).children('.text').html().toLowerCase()
		SITE_ENT.get_search_input().val( value ).focus()
		SITE_ENT.get_search_button().click()

	collection  = $(".js-suggest")
	collPointer = 0
	collChosed  = null

	$(document).on 'keydown', (ev)->
		up = down = false
		up = true if ev.which is 38
		down = true if ev.which is 40
		if collection.length > 0
			collChosed.removeClass('js-suggest-hover') if collChosed
			#new
			if down
				collPointer++
				collChosed  = $(collection[collPointer%collection.length]).addClass('js-suggest-hover')
				setValue( collChosed.text() )
				return false
			if up
				collPointer--
				collPointer = collection.length - 1 if collPointer < 0
				collChosed = $(collection[collPointer%collection.length]).addClass('js-suggest-hover')
				setValue( collChosed.text() )
				return false

	showContent()



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
		#saving chooosed point
		choosed = null

		#set default value
		SITE_ENT.get_language_container().find("input").each ->
			window.CURRENT_LANGUAGE = $(this).val() if $(this).attr("checked")
			$(this).parent().addClass 'bold' if $(this).attr("checked")
			choosed = $(this).parent() if $(this).attr('checked')

		#update on click
		SITE_ENT.get_language_container().find("input").on 'click', ->
			window.CURRENT_LANGUAGE = $(this).val()
			if choosed
				choosed.removeClass 'bold'
			choosed = $(this).parent()
			choosed.addClass 'bold'
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

new Module {
	name : "Set minimal height to page via javascript"
	autoload : true
	init : ->
		$(".page").css("min-height", $(document).height()*2/3 - $('footer').height())
}


# new Module {
# 	name : "upload images via javascript"
# 	autoload : true
# 	init : ->
# 		url = 'http://' + location.host + $("#js-image-placeholder-0").attr("data-src")
# 		hash = Math.floor(Math.random() * 100011)
# 		$("#js-image-placeholder-0").parent().html("<img  src=#{url} id=#{hash} />")
# 		document.getElementById(hash).setAttribute('style', '123123')
# }
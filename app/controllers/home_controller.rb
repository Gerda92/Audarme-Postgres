class HomeController < ApplicationController

	def push
		Parser.push_words 'kz'
	end

end


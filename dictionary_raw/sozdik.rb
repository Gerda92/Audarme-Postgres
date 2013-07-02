require "net/http"
require "uri"
require "unicode"
require_relative "parser.rb"

class Sozdik

	def self.get_word word
		url = URI.parse("http://sozdik.kz/ru/dictionary/translate/kk/ru/" + URI::encode(word) + "/")
		req = Net::HTTP::Get.new(url.path)

		headers = {
			"Host" => "sozdik.kz",
			"User-Agent" => "Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1",
			"Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
			"Accept-Language" => "ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3",
			"Accept-Charset" => "windows-1251,utf-8;q=0.7,*;q=0.7",
			"Content-Type" => "text/html; charset=utf-8",
			"Referer" => "http://sozdik.kz/"
		}
		headers.each do |k , v|
			req[k] = v
		end

		res = Net::HTTP.new(url.host, url.port).start do |http|
		    http.request(req)
		end

		if !res.body.match(/dictionary_article_translation"><p>(.*)<\/p><\/div>/)			
			return false
		else
			return res.body.match(/dictionary_article_translation"><p>(.*)<\/p><\/div>/)
				.captures[0]
		end

	end

	def self.get_absent_words lang
		defs = File.open(lang + "defs.html", "r:UTF-8").lines
		missed = File.open(lang + "missed2.txt", "w:UTF-8")
		next_def = prev_def = get_title(defs.next)
		
		File.open(lang + "missed.txt", "r:UTF-8").each do |word|
			#puts next_def
			if !word.chomp!.nil? && (Parser.indexed_name(word)
				.< Parser.indexed_name(next_def))
				if (word != prev_def)
					missed.write(word+"\n")
				end
			else
				prev_def = next_def
				next_def = get_title(defs.next)
			end
		end

	end

	def self.get_title(s)
		title = s.scan(%r{<h2>(.*)</h2>}m)
		if title[0].nil?
			nil
		else
			title[0][0]
		end
	end


end

#puts Sozdik.get_word gets.chomp.encode("utf-8")

Sozdik.get_absent_words 'kz'
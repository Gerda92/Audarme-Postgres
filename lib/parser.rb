class Parser
	def self.push_words lang
		File.open("dictionary_raw/" + lang + "defs.html", "r:UTF-8").each do |s|
			title = get_title(s)
			if (title[0].nil? || Word.where(name: title[0][0]).all.count > 0)
				next
			end
			d = get_def(s)
			definition = fix_anchors(d[0][0])
			if (definition.nil?)
				raise d.inspect
			end
			word = Word.new
			word.name = title[0][0]
			word.language = lang
			word.definition = definition
		    word.save
		end
	end

	def self.get_title(s)
		title = s.scan(%r{<h2>(.*)</h2>}m)
	end

	def self.get_def(s)
		definition = s.scan(%r{<p>(.*)</p>}m)
	end

	def self.fix_anchors(s)
		s.gsub!(/href="[^"]*"/ix, 'href="#"')
		s.gsub!(/\slangfrom="[^"]*"/ix, '')
		s.gsub!(/\slangto="[^"]*"/ix, '')
		s
	end
end
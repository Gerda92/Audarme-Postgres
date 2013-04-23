class Parser
	def self.push_words lang
		File.open("dictionary_raw/" + lang + "defs.html", "r:UTF-8").each do |s|
			title = get_title(s)
			if (title[0].nil? || Word.where(language: lang, name: title[0][0]).all.count > 0)
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

	def self.generate_json(s)
		s.gsub!(/<br[^>]*>[ ]*/,'')
		json = {}
		if (s.match(/<abbr[^>]*>([^<>]*)<[^>]*abbr>/))
			json['attr'] = s.match(/<abbr[^>]*>([^<>]*)<[^>]*abbr>/).captures
		end
		s.gsub!(/<abbr[^>]*>([^<>]*)<[^>]*abbr>/,'')
		s.gsub!(/<br[^>]*>[ ]*/,'')
		if s =~ /^I[.].*/
			json['type'] = "disambiguation"
			json['list'] = []
			s.split(/[XVI]+[.]/).each do |disambig|
				if (disambig.length > 0)
					json['list'] << self.generate_json(disambig)
				end
			end
		elsif s =~ /^1[.].*/
			json['type'] = "parts of speech"
			json['list'] = []
			s.split(/[0-9]+[.]/).each do |parts|
				json['list'] << self.generate_json(parts)
			end
		elsif s =~ /^1[)].*/
			json['type'] = "equivalents"
			json['list'] = []
			s.split(/[0-9]+[)]/).each do |eq|
				json['list'] << self.generate_json(eq)
			end
		else
			return s		
		end
	end

	def self.indexed_name(name)
		chars = Hash[* [1040, 1240, 1072, 1241, 1043, 1170, 1075, 1171, 1050, 1178, 1082, 1179, 1053,
			1186, 1085, 1187, 1054, 1256, 1086, 1257, 1059, 1198, 1091, 1199, 1061, 1210, 1093, 1211,
			1067, 73, 1099, 105]].invert
		map = {}
		chars.each do |k,v|
			map[k] = v.chr + '1'
		end
		map[1200] = 1059.chr + '2'; map[1201] = 1091.chr + '2'
		map[1030] = 1067.chr + '1'; map[1110] = 1099.chr + '1'
		index = ''
		name.each_char do |c|
			index += map.key?(c.ord) ? map[c.ord] : c + '0'
		end
		index
	end

	def self.filter_letters
		letters = {1240.chr => 1040.chr,
			1241.chr => 1072}
		Word.where(:language => 'kz').limit(1000).each do |word|
			break if letters.length >= 9
			word.name.each_char do |c|
				if (!letters.include?(c) && (c.ord<1040||c.ord>1103))
					letters << c
				end
			end
		end
		letters
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
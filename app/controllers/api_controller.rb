class ApiController < ApplicationController
	def define
		@word = Word.where(:language => params['lang'], :name => params['name']).first
		#raise Word.where(:language => 'ru').order(:name).limit(100).inspect
		json = generate_json(@word.definition)
		render :text => '<pre>' + JSON.pretty_generate(json) + '</pre>'
	end

	def words
		words = Word.order(:indexed_name).limit(1000)
		names = words.collect{|w| w.name}
		raise names.inspect
	end

	def indexed_name
		name = params[:word]
		chars = Hash[* [1040, 1240, 1072, 1241, 1043, 1170, 1075, 1171, 1050, 1178, 1082, 1179, 1053,
			1186, 1085, 1187, 1054, 1256, 1086, 1257, 1059, 1198, 1091, 1199, 1061, 1210, 1093, 1211,
			1067, 73, 1099, 105]].invert
		map = {}
		chars.each do |k,v|
			map[k] = v.chr + '1'
		end
		map[1200] = 1059.chr + '2'; map[1201] = 1091.chr + '2'
		map[1030] = 1067.chr + '1'; map[1110] = 1099.chr + '1'
		raise map.inspect
		index = ''
		name.each_char do |c|
			index += map.key?(c.ord) ? map[c.ord] : c + '0'
		end
		index
	end

	def generate_json(s)
		s.gsub!(/<br[^>]*>/,' '); s.strip!
		json = Hash.new {|h,k| h[k]=[]}
		while (abbr = s.match(/^<abbr[^>]*>([^<>]*)<[^>]*abbr>[ ]*/))
			json['attr'] << abbr.captures[0]
			s.sub!(/^<abbr[^>]*>[^<>]*<[^>]*abbr>[ ]*/,'')
		end
		if s =~ /^I[.].*/
			json['type'] = "disambiguation"
			s.split(/[XVI]+[.]/).each do |m|
				json['list'] << generate_json(m) if !m.empty?
			end
		elsif s =~ /^1[.].*/
			json['type'] = "parts of speech"
			s.split(/[0-9]+[.]/).each do |m|
				json['list'] << generate_json(m) if !m.empty?
			end
		elsif s =~ /^1[)].*/
			json['type'] = "equivalents"
			s.split(/[0-9]+[)]/).each do |m|
				json['list'] << generate_json(m) if !m.empty?
			end
		else
			s.split(/<span>/)[0].split(/;/).each do |m|
				json['meanings'] << m.strip if !m.empty?
			end
			s.scan(/<span>([^<>]*)<\/span>/) do |m|
				json['examples'] << m[0].strip	if !m.nil?
			end
		end
		return json
	end
end

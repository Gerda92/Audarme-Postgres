class Lemmatizer

	@@zhalgaular = Hash.new([]);

	def self.var_init
		zh = ''
		File.open("kzzh.txt", "r:UTF-8").each do |s|
			#puts s
			next if s.strip!.nil? || s.empty?
			if  s.match(/(.*):/) && zh = s.match(/(.*):/).captures[0]
				@@zhalgaular[zh] = []
			else
				s.split(/[\s\t\n\r]+/).each do |z|
					@@zhalgaular[zh] << z
				end
			end
		end
		@@zhalgaular
	end

	def self.lemmatize word
		lemmas = [word]
		var_init if @@zhalgaular.empty?
		['septik zh.', 'taueldik zh.', 'koptik zh.'].each do |type|
			for i in 0..lemmas.size-1
				w = lemmas[i]
				@@zhalgaular[type].each do |instance|
					if (w =~ /#{instance}$/)
						lemmas << w.gsub(/#{instance}$/, '')
					end
				end
			end
		end	
		lemmas
	end

end
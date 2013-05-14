#encoding: UTF-8
require 'net/http'
require 'uri'

$stdin = File.open('rudefs.html','r');
#$stdout = File.open('out.txt','w');
def read_word()
	s = gets
	return s
end

def get_title(s)
	definition = s.scan(%r{<h2>(.*)</h2>}m)
end

def get_def(s)
	definition = s.scan(%r{<p>(.*)</p>}m)
end

def fix_anchors(s)
	while(s.sub!(/[\/][?]sid.{27}/, ''))
	end
	while(s.sub!(/\/ru\/dictionary/,''))
	end
	while(s.sub!(/ langfrom=".{2}"/,''))
	end
	while(s.sub!(/ langto=".{2}"/,''))
	end
	s
	# s.scan(%r{<a href="([^"]*)"}) {|a| 
	# 	a.each do |w|
	# 		w = w.sub!(/[\/][?]sid.{26}/, '')
	# 		w = w.sub!(/\/ru\/dictionary/,'')
	# 		#puts "#{w}"
	# 	end
	# }
end

counter = 0
while(s = read_word)
	title = get_title(s)
	definition = get_def(s)
	definition = fix_anchors(definition[0][0])
	counter += 1
	postData = Net::HTTP.post_form(URI.parse('http://localhost:3000/words/add_word_ru'), 
	                               {'name'=>title[0][0], 'definition'=>definition})
	if (counter.modulo(100)==0)
		puts counter
	end
end
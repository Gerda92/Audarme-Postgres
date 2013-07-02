# require 'net/http'
# require 'uri'

# $stdin = File.open('kzwords.txt','r');
# $stdout = File.open('out.txt','w');
# def read_word()
#   s = gets
#   return s
# end

# def get_ans(s)
#   definition = s.scan(%r{<p>(.*)</p>}m)
# end

# while (s = read_word)
#   s.chomp!
#   postData = Net::HTTP.post_form(URI.parse('http://localhost:3000/words/word_exist'), 
#                                   {'name'=> s})
#   ans = get_ans(postData.body)[0][0]
#   if (ans=='false')
#     puts s
#   end  
# end
$stdin = File.open('rudefs2.html','r');
counter = 0
while (s=gets)
  counter += 1
end
puts counter
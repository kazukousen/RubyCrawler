require 'net/http'

Net::HTTP.start('search.hatena.ne.jp',80) do |http|
  response = http.post('/questionsearch/', 'word=ruby')
  puts response.body
end

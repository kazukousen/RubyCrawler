require 'nokogiri'
require 'open-uri'

url = 'http://b.hatena.ne.jp/i101330/bookmark'
opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36 Vivaldi/1.0.403.24'

doc = Nokogiri::HTML(open(url, opt))
nodesets = doc.xpath('//h3/a')

nodesets.each do |nodeset|
  puts nodeset.text
  puts nodeset.[]('href')
  puts "\n"
end

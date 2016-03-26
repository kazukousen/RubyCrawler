require 'nokogiri'
require 'open-uri'

class Site
  def initialize(url: "", opt: {})
    @url = url
    @opt = opt
  end
  attr_reader :url, :opt

  def page_source
    @page_source ||= open(url, opt)
  end

  def output(formatter_klass)
    formatter_klass.new(self).format(parse)
  end
end

class HatenaBookmark < Site
  def parse
    doc = Nokogiri::HTML(page_source)
    nodesets = doc.xpath('//h3/a')
  end
end

class Formatter
  def initialize(site)
    @url = site.url
    @opt = site.opt
  end
  attr_reader :url, :opt
end

class SubjectLinkFormat < Formatter

  def format(nodesets)

    nodetimes = (0..19)
    subjects = nodetimes.map{|i| nodesets[i].text}
    links =  nodetimes.map{|i| nodesets[i].[]('href')}

    list = {}
    list = subjects.zip(links).map do |subject, link|
      {subject: subject, link: link}
    end

    list
  end
end


url = 'http://b.hatena.ne.jp/i101330/bookmark'
opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36 Vivaldi/1.0.403.24'

site = HatenaBookmark.new(url:url, opt:opt)
puts site.output(SubjectLinkFormat)

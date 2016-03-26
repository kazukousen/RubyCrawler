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

  def output(formatter_klass, part)
    formatter_klass.new(self).format(parse, part)
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
  module Pagination
    First = (0..9)
    Last = (10..19)
  end

  def format(nodesets, part)
    page = case part
    when 0
      Pagination::First
    when 1
      Pagination::Last
    end

    subjects = page.map{|i| nodesets[i].text}
    links =  page.map{|i| nodesets[i].[]('href')}

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
puts site.output(SubjectLinkFormat, ARGV.first.to_i)

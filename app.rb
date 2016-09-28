require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

host = 'http://rubykaigi.org'
path = '/2016/schedule/'
url = host + path

url_list = []
open(url) do |f|
  doc = Nokogiri::HTML(f.read)
  doc.css('table a').each do |a|
    url_list << host + a['href']
  end
end

url_list.each do |url|
  p url
  open(url) do |f|
    doc = Nokogiri::HTML(f.read)
    doc.css('.section p').each do |g|
      p g.text
    end
  end
end

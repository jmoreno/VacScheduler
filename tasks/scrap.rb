require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pp'

url = "http://www.aepap.org/vacunas/calendarios-espanoles"
data = []
doc = Nokogiri::HTML(open(url))
doc.css('.peque').search('tr').each do |tr|
  row = []
  tr.search('td').each do |td|
    row << td.search('p').map(&:text)
  end
  data << row
end
pp data
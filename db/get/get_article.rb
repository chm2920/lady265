# coding: utf-8  

require 'open-uri'
require 'iconv'

url = "http://clothing.lady8844.com/clothing/fashion/ol/2011-03-30/1301454973d555183.html"
last_url = url.split("/").last.to_s

puts url
puts "========================================================================="
gets = open(url).read
#gets = Iconv.conv("UTF-8//IGNORE", "gb2312//IGNORE", gets)

#gets = Iconv.conv("gb2312//IGNORE", "UTF-8//IGNORE", gets)
#puts Iconv.conv("gb2312//IGNORE", "UTF-8//IGNORE", "：")
#t = Iconv.conv("UTF-8//IGNORE", "gb2312//IGNORE", "：")

summary = ""
content = ""
pages = []

gets.scan(/<div class="guide_txt">(.*?)<\/div>/m) do |c|
  summary = c[0].strip.to_s.force_encoding('UTF-8').downcase
end

gets.scan(/div id="content_pagelist"(.*?)>(.*?)<\/div>/) do |e, f|
  pages = f.to_s.scan(/href='(.*?)'/).uniq
end

c = []
for page in pages
  page = page[0].to_s
  if page==last_url
    sub_get = gets
  else
    puts page
    sub_get = open(url.gsub(last_url, page)).read
  end
  sub_get.scan(/<span id="TEXT_CONTENT" style="margin-top:3px;display:block;">(.*?)<\/span>/m) do |d|
    c << d[0].strip.to_s.force_encoding('UTF-8').downcase
  end
end
content = c.join("<hr><hr>")

summary = summary.gsub(" ", "")
summary = summary.gsub("\t", "")
summary = summary.gsub("\n", "")
content = content.gsub(/<a(.*?)>/, "")
content = content.gsub(/<\/a>/, "")
content = content.gsub(/<htm(.*?)>/, "")
content = content.gsub(/<met(.*?)>/, "")
content = content.gsub(/<bod(.*?)>/, "")
content = content.gsub(/<\/body>/, "")
content = content.gsub(/<head(.*?)>/, "")
content = content.gsub(/<\/head>/, "")

#
#b = gets.scan(/<h2>(.*?)<\/h2>/m)[0].to_s
#
#b.scan(/[\u4e00-\u9fa5]*[\uff1a]*(.*?)\n(.*?)/m) do |c, d|
#puts " ============ "
#  puts c.to_s
  f = File.new("result.txt", "w:UTF-8")
  f.puts summary
  f.puts "=============="
  f.puts content
  f.close
#end